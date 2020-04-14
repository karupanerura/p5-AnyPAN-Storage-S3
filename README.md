# NAME

CPAN::MirrorMerger::Storage::S3 - CPAN::MirrorMerger storage plugin for Amazon S3

# SYNOPSIS

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

# DESCRIPTION

CPAN::MirrorMerger::Storage::S3 is [CPAN::MirrorMerger](https://metacpan.org/pod/CPAN%3A%3AMirrorMerger) storage plugin for Amazon S3.

# LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

karupanerura <karupa@cpan.org>
