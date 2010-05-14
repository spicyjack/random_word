use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Random::Word',
    AUTHOR              => 'Brian Manning <bmanning@qualcomm.com>',
    VERSION_FROM        => 'lib/Random/Word.pm',
    ABSTRACT_FROM       => 'lib/Random/Word.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Random-Word-*' },
);
