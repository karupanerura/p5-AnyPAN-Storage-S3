package AnyPAN::CLI::S3Storage;
use strict;
use warnings;

use parent qw/AnyPAN::CLI/;

use Class::Accessor::Lite ro => [qw/
    aws_access_key_id
    aws_secret_access_key
    aws_session_token
    s3_timeout
    s3_bucket_name
    s3_bucket_region
/];

use Pod::Usage qw/pod2usage/;
use AnyPAN::Storage::S3;
use AnyPAN::Storage::S3::Adapter::NetAmazonS3;

sub create_option_specs {
    my $class = shift;
    my @specs = $class->SUPER::create_option_specs();
    return (
        @specs,
        'aws-access-key-id=s',
        'aws-secret-access-key=s',
        'aws-session-token=s',
        's3-timeout=f',
        's3-bucket-name=s',
        's3-bucket-region=s',
    );
}

sub convert_options {
    my ($class, $opts, $argv) = @_;

    # env default
    $opts->{'aws-access-key-id'}     ||= $ENV{AWS_ACCESS_KEY_ID};
    $opts->{'aws-secret-access-key'} ||= $ENV{AWS_SECRET_ACCESS_KEY};
    $opts->{'aws-session-token'}     ||= $ENV{AWS_SESSION_TOKEN};

    # required options
    pod2usage(1) unless $opts->{'aws-access-key-id'};
    pod2usage(1) unless $opts->{'aws-secret-access-key'};
    pod2usage(1) unless $opts->{'s3-bucket-name'};
    pod2usage(1) unless $opts->{'s3-bucket-region'};

    my %args = $class->SUPER::convert_options($opts, $argv);
    $args{aws_access_key_id}     = $opts->{'aws-access-key-id'};
    $args{aws_secret_access_key} = $opts->{'aws-secret-access-key'};
    $args{aws_session_token}     = $opts->{'aws-session-token'} || undef;
    $args{s3_timeout}            = $opts->{'s3-timeout=f'} || 30;
    $args{s3_bucket_name}        = $opts->{'s3-bucket-name'};
    $args{s3_bucket_region}      =$ opts->{'s3-bucket-region'};
    return %args;
}

sub create_storage {
    my $self = shift;

    require Net::Amazon::S3;
    my $s3 = Net::Amazon::S3->new(
        aws_access_key_id     => $self->aws_access_key_id,
        aws_secret_access_key => $self->aws_secret_access_key,
        $self->aws_session_token ? (
            aws_session_token => $self->aws_session_token,
        ) : (),
        retry   => 1,
        secure  => 1,
        timeout => $self->s3_timeout,
    );

    require Net::Amazon::S3::Client;
    my $client = Net::Amazon::S3::Client->new(s3 => $s3);

    my $s3_bucket = $client->bucket(
        name   => $self->s3_bucket_name,
        region => $self->s3_bucket_region,
    );
    my $adapter = AnyPAN::Storage::S3::Adapter::NetAmazonS3->new(s3_bucket => $s3_bucket);
    return AnyPAN::Storage::S3->new(adapter => $adapter);
}

1;
__END__
