use Moops;
use Moo;
require MooX::Options;

our $VERSION    = 0.01;
our %GIT_REPOS  = (
    rakudo => 'https://github.com/rakudo/rakudo.git',
);

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

    role PackageManager {
        use MooX::Options;
        option 'install_panda' => (
            short       => 'panda',
            is          => 'ro',
            required    => 0,
            doc         => 'Install panda, a module installer for Rakudo Perl6',
        );
    }
} # class Options


class App::p6brew with Options::VM with Options::Compiler with Options::PackageManager {
    use Cwd;
    use Git::Repository;
    use System::Command;
    use MooX::Options;
    use Path::Class;
    use IO::Handle;

    option verbose => (
        is  => 'ro',
        isa => Bool,
    );

    method install(Str :$save_dir) {
        foreach my $compiler (@{ $self->install_compiler }) {
            my $dir = Path::Class::Dir->new( $save_dir // cwd(), $compiler );

            my $rakudo_repo = try {
                say "Cloning to: $dir";
                my $git = Path::Class::Dir->new($dir, '.git');
                Git::Repository->run( clone => $GIT_REPOS{$compiler}, { quiet => 1 }, $dir ) if(!-f $git);

                my $repo = Git::Repository->new( git_dir => $git, { quiet => 1 } );
                $repo->run( 'fetch',           { quiet => 1} );
                $repo->run( checkout => 'nom', { quiet => 1} );
            } catch { die "Failed to clone repository! Cannot continue. $_" };

            my @command = ($^X, Path::Class::File->new($dir, 'Configure.pl'));
            push( @command, '--backends=' . join(',', @{$self->install_vm}) ); 
            push( @command, '--gen-nqp', '--make-install'                   );
            push( @command, '--gen-moar'                                    ) 
                if grep { /^moar/ } @{$self->install_vm};

            say "Installing. This may take awhile...";

            my $cmd      = System::Command->new(@command, { cwd => $dir });
            my $temp     = Path::Class::tempdir;
            my $log_file = Path::Class::File->new($temp, 'p6brew.out');

            say "tail -f $log_file";
            {
                my $cmd_stdout = $cmd->stdout;
                my $cmd_stderr = $cmd->stderr;
                open my $out_fh, '>', $log_file;
                $out_fh->autoflush(1);
                while (defined(my $out = <$cmd_stdout>) or defined(my $err = <$cmd_stderr>)) {
                    print {$out_fh} ($out // $err);
                    say($out // $err) if $self->verbose;
                }
                close $out_fh;
            }
            die "Failed" unless $cmd->exit == 0; 
            say "Install OK";
        }
    } # /method install
} # /class App::p6brew



1;



__END__