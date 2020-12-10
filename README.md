# NAME

AnyPAN::Storage::S3 - AnyPAN storage plugin for Amazon S3

# SYNOPSIS

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

# DESCRIPTION

AnyPAN::Storage::S3 is [AnyPAN](https://metacpan.org/pod/AnyPAN) storage plugin for Amazon S3.

# LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

karupanerura <karupa@cpan.org>
