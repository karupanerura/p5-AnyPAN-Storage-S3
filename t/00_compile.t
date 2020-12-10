use strict;
use Test::More 0.98;

use_ok $_ for qw(
    AnyPAN::Storage::S3
    AnyPAN::Storage::S3::Adapter::NetAmazonS3
);

done_testing;

