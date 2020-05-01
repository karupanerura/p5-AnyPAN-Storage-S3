package CPAN::MirrorMerger::Storage::S3;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.02";

use Class::Accessor::Lite ro => [qw/retry_policy adapter/];

use Carp qw/croak/;
use Path::Tiny ();

use CPAN::MirrorMerger ();

sub new {
    my ($class, %args) = @_;
    croak 'adapter required' unless defined $args{adapter};
    $args{retry_policy} ||= $CPAN::MirrorMerger::DEFAULT_RETRY_POLICY;
    bless \%args, $class;
}

sub copy {
    my ($self, $from_path, $save_key) = @_;
    $self->retry_policy->apply_and_doit(sub {
        $self->adapter->upload($from_path, $save_key);
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

=head1 NAME

CPAN::MirrorMerger::Storage::S3 - CPAN::MirrorMerger storage plugin for Amazon S3

=head1 SYNOPSIS

    use CPAN::MirrorMerger;
    use CPAN::MirrorMerger::Storage::S3;
    use CPAN::MirrorMerger::Storage::S3::Adapter::NetAmazonS3;
    use Net::Amazon::S3;

    my $s3 = Net::Amazon::S3->new(...);
    my $adapter = CPAN::MirrorMerger::Storage::S3::Adapter::NetAmazonS3->new(s3 => $s3);
    my $storage = CPAN::MirrorMerger::Storage::S3->new(adapter => $adapter);

    use CPAN::MirrorMerger::Storage::Directory;

    my $merger = CPAN::MirrorMerger->new();
    $merger->add_mirror('http://backpan.cpantesters.org/');
    $merger->add_mirror('https://cpan.metacpan.org/');
    $merger->merge()->save($storage);

=head1 DESCRIPTION

CPAN::MirrorMerger::Storage::S3 is L<CPAN::MirrorMerger> storage plugin for Amazon S3.

=head1 LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

karupanerura E<lt>karupa@cpan.orgE<gt>

=cut

