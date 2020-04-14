use strict;
use Test::More 0.98;

use_ok $_ for qw(
    CPAN::MirrorMerger::Storage::S3
    CPAN::MirrorMerger::Storage::S3::Adapter::NetAmazonS3
);

done_testing;

