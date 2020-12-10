package AnyPAN::Storage::S3;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.05";

use Class::Accessor::Lite ro => [qw/retry_policy adapter/];

use Carp qw/croak/;
use Path::Tiny ();

use AnyPAN::RetryPolicy::ExponentialBackoff;

our $DEFAULT_RETRY_POLICY = AnyPAN::RetryPolicy::ExponentialBackoff->new(
    max_retries   => 5,
    interval      => 1,
    jitter_factor => 0.05,
);

sub new {
    my ($class, %args) = @_;
    croak 'adapter required' unless defined $args{adapter};
    $args{retry_policy} ||= $DEFAULT_RETRY_POLICY;
    bless \%args, $class;
}

sub copy {
    my ($self, $from_path, $save_key) = @_;
    $self->retry_policy->apply_and_doit(sub {
        $self->adapter->upload($from_path, $save_key);
    });
}

sub exists :method {
    my ($self, $save_key) = @_;
    return $self->retry_policy->apply_and_doit(sub {
        return $self->adapter->exists($save_key);
    });
}

sub fetch {
    my ($self, $save_key) = @_;
    return $self->retry_policy->apply_and_doit(sub {
        my $tempfile = Path::Tiny->tempfile(UNLINK => 1);

        my $downloaded = $self->adapter->download($save_key, $tempfile->cached_temp);
        return unless $downloaded;

        return $tempfile;
    });
}

1;
__END__

=encoding utf-8

=for stopwords AnyPAN

=head1 NAME

AnyPAN::Storage::S3 - AnyPAN storage plugin for Amazon S3

=head1 SYNOPSIS

    use AnyPAN::Merger;
    use AnyPAN::Storage::S3;
    use AnyPAN::Storage::S3::Adapter::NetAmazonS3;
    use Net::Amazon::S3;

    my $s3 = Net::Amazon::S3->new(...);
    my $adapter = AnyPAN::Storage::S3::Adapter::NetAmazonS3->new(s3 => $s3);
    my $storage = AnyPAN::Storage::S3->new(adapter => $adapter);

    use AnyPAN::Storage::Directory;

    my $merger = AnyPAN::Merger->new();
    $merger->add_source('http://backpan.cpantesters.org/');
    $merger->add_source('https://cpan.metacpan.org/');
    $merger->merge()->save($storage);

=head1 DESCRIPTION

AnyPAN::Storage::S3 is L<AnyPAN> storage plugin for Amazon S3.

=head1 LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

karupanerura E<lt>karupa@cpan.orgE<gt>

=cut

