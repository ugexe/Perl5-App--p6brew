use strict;
use Test::More tests => 3;

use App::p6brew;

my $brew = App::p6brew->new;
is( $brew->install_vm->[0],       'moar',   "Default VM" );
is( $brew->install_compiler->[0], 'rakudo', "Default Compiler" );

{
    my $brew = App::p6brew->new(install_vm => [qw/jvm/]);
    is( $brew->install_vm->[0], 'jvm', "Changed VM via new" );
}