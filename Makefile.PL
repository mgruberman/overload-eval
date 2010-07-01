use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'overload::eval',
    AUTHOR        => 'Joshua ben Jore <jjore@cpan.org>',
    VERSION_FROM  => 'lib/overload/eval.pm',
    ABSTRACT_FROM => 'lib/overload/eval.pm',
    PREREQ_PM     => { 'Test::More' => 0 },
    dist          => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'overload-eval-*' },
);
