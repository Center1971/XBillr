package Config::File::RRJSON;

use File::Slurp;
use Data::Dumper::Concise;

use Config::File::RRJSON::Parser;

use Moops;

$| = 1;

class Config::File::RRJSON 1.0
{
    has parser =>
    (
        is       => 'rwp',
        isa      => 'Config::File::RRJSON::Parser',
        reader   => 'parser',
        writer   => '_parser',
        init_arg => undef,
    );

    has file =>
    (
        is       => 'rwp',
        isa      => Str,
        reader   => 'file',
        writer   => '_file',
    );

    #########################################################################
    #
    # the constructor wrapper
    #
    #  parameters:
    #   @_ - the config file
    #
    #  returns:
    #   the next call in the class hierarchy
    #
    #  notes:
    #   the method allows for a constructor call just with a file name
    #
    #########################################################################

    around BUILDARGS
    {
        return $self->$next(@_ == 1
                            ? ref($_[0])
                                ? $_[0]
                                : { file => $_[0] }
                            : { @_ }
                           );
    }

    #########################################################################
    #
    # method to initialize the object
    #
    #  parameters:
    #   none
    #
    #  returns:
    #   the object with the parsed config file
    #
    #  notes:
    #
    #########################################################################

    method BUILD
    {
        $self->_parser(Config::File::RRJSON::Parser->new());

        my $content = read_file($self->file);

        my $config = $self->parser->startrule($content);

        print Dumper($config);
    }
}
