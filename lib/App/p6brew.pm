use Moops;
use Moo;
require MooX::Options;

our $VERSION = 0.01;

class Options {
    role VM {
        use MooX::Options;
        option 'install_vm' => (
            short       => 'vm',
            is          => 'rw',
            format      => 's@',
            default     => sub {['moar']},
            autosplit   => 1,
            required    => 1,
            doc         => 'VM backend(s) to install',
        );
    }


    role Compiler {
        use MooX::Options;
        option 'install_compiler' => (
            short       => 'c',
            is          => 'rw',
            format      => 's@',
            default     => sub {['rakudo']},
            autosplit   => 1,
            required    => 0,
            doc         => 'Perl6 compiler(s) to install',
        );
    }

    role ModuleInstaller {
        use MooX::Options;
        option 'install_panda' => (
            short       => 'panda',
            is          => 'ro',
            required    => 0,
            doc         => 'Install panda, a module installer for Rakudo Perl6',
        );
    }
} # class Options


class App::p6brew with Options::VM with Options::Compiler with Options::ModuleInstaller {
    use MooX::Options;
    option verbose => (
        is  => 'ro',
        isa => Bool,
    );


    method install(Str :$path = '.') {
        say "path:" . $path;
        say "vm:"   . join(',', $self->install_vm);
    }


} # class App::p6brew



1;



__END__