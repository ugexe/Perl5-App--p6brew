use 5.14;
use strict;
use warnings; 
use ExtUtils::MakeMaker;

my $pm =   'lib/App/p6brew.pm';
my $repo = 'https://github.com/ugexe/Perl5-App--p6brew';
my $bugs = 'https://github.com/ugexe/Perl5-App--p6brew/issues';

WriteMakefile (  
    NAME => 'App::p6brew',
    EXE_FILES => [
        "bin/p6brew"
    ],
    VERSION_FROM        => $pm, 
    ABSTRACT            => 'Install and manage multiple Perl6 installations',
    AUTHOR              => 'ugexe <nlogan@gmail.com>',
    LICENSE             => 'perl',
    MIN_PERL_VERSION    => '5.14',
    PREREQ_PM           => {
        'ExtUtils::Install'   => '1.46',
        'ExtUtils::MakeMaker' => '6.58',
        'Module::Build'       => '0.38',        
        'Moops'               => 0,
        'MooX::Options'       => 0,
        'Git::Repository'     => 0,
        'IO::Handle'          => 0,
        'System::Command'     => 0,
        'Path::Class'         => 0,
    },
    TEST_REQUIRES => {
        'Test::More' => 0,
    },
    META_MERGE => {
        resources => {
            repository => $repo, 
            bugtracker => $bugs,
        },
        provides => {
            'App::p6brew' => {
                file    => 'lib/App/p6brew.pm',
                version => '0.01',
            },
        },

    },
);
