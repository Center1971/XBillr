#############################################################################
#
# Copyright (c) by jeff (jeff@lipsia.de)
#
# Author:  jeff
#
# File:    $Id: File.pm,v 1.23 2018/04/25 09:41:55 jeff Exp $
#
# Purpose: a class to deal with windows like config (.ini) files
#
# Created: 98/12/22
#
# Update:  $Date: 2018/04/25 09:41:55 $
#
# Notes:
#
#############################################################################

package Config::File;
require 5.6.1;

no warnings 'redefine';

use Parse::RecDescent;

use Config::File::Parser;
use Config::File::Section;
use Config::File::Variable;

use XML::Generator qw(:pretty);

use Carp;

use strict;
no strict 'refs';
use vars qw($VERSION $DefaultClass $DefaultGrammar $AUTOLOAD @ISA @EXPORT);

($VERSION = '$Revision: 1.23 $') =~ s/^\$Revision[:]\s*|\s*\$$//g;

$DefaultClass = 'Config::File' unless defined $Config::File::DefaultClass;

require Exporter;
@ISA = qw(Exporter);

@EXPORT = qw(EXPAND_NONE EXPAND_VARS EXPAND_ENV EXPAND_ALL
	BUFFERED CASE_SENSITIVE WRITE_AUTOMATICALLY);

use constant EXPAND_NONE         => 0;
use constant EXPAND_VARS         => 1;
use constant EXPAND_ENV          => 2;
use constant EXPAND_ALL          => 255;
use constant UNBUFFERED          => 0;
use constant BUFFERED            => 1;
use constant CASE_SENSITIVE      => 2;
use constant WRITE_AUTOMATICALLY => 4;

my $Debug = 1;

#############################################################################
#
# the constructor
#
#  parameters:
#   $file    - the name of the config file to deal with
#   $options (o) - a processing options hash ref;
#                  the options hash ref may contain the following key/value 
#                  pairs:
#                  {
#                      EXPAND => EXPAND_NONE | EXPAND_VARS  | 
#                                EXPAND_ENV | EXPAND_ALL
#                      MODE   => BUFFERED | CASE_SENSITIVE | 
#                                WRITE_AUTOMATICALLY
#                  }
#   $grammar (o) - the grammar to use;
#
#  returns:
#   the new instance of the class
#
#############################################################################

sub new
{
	my ($class, $file, $options, $grammar) = @_;

	my $self = {};

	bless $self, ref $class || $class || $DefaultClass;

	$self->ProcessingOptions($options ? $options : {});

    $self->{_options}->{MODE} //= BUFFERED;

    $self->SectionAlias($options->{ALIASES}) if defined $options->{ALIASES};

	$self->Buffered($self->{_options}->{MODE});

	$self->{_changed}  = 0;
	$self->{_readtime} = 0;

	$self->{_parser} = $grammar ?
		               new Parse::RecDescent($grammar) :
					   new Config::File::Parser();
	$self->{_parser}->{_config} = $self;
	$self->{_file} = '';

	return undef unless -f $file;

    # disable automatic writing during file parsing
    my $write_automatically = $self->{_options}->{MODE} & WRITE_AUTOMATICALLY;
    $self->{_options}->{MODE} &= ~ WRITE_AUTOMATICALLY;

	$self->File($file);

    # enable automatic writing if necessary
    $self->{_options}->{MODE} |= WRITE_AUTOMATICALLY if $write_automatically;

	return $self;
}

#############################################################################
#
# a method to change the default behaviour of buffered writing (i.e.
# writing the configuration to the file at the destructor
#
#  parameters:
#   $buffered - 0 (unbuffered) or 1 (buffered); default: 1
#
#  returns:
#   the new value of the flag
#
#############################################################################

sub Buffered
{
	my ($self, $buffered) = @_;

	$self->{_buffered} = $buffered if defined $buffered;

	return $self->{_buffered};
}

sub buffered { return shift->Buffered(@_) };

#############################################################################
#
# accessor method for the processing options hash ref
#
#  parameters:
#   $options - the optional new options hash ref
#
#  returns:
#   the (new) options hash ref
#
#############################################################################

sub ProcessingOptions
{
	my ($self, $options) = @_;

	$self->{_options} = $options if defined $options;

	return $self->{_options};
}

sub processing_options { return shift->ProcessingOptions(@_) };

#############################################################################
#
# the method to expand variables
#
#  parameters:
#   none
#
#  returns:
#   the object itself for method concatenation
#
#  notes:
#   variable expansion is done per section, so the same variable name can
#   be used in different sections. if the variable to be expanded is not 
#   defined in the section, the variable from the 
#   $Config::File::Section::MainSection section is used
#   the variable can be prefixed by the section and colon like
#   $my_section:variable
#
#############################################################################

sub Expand
{
	my ($self) = @_;

    # first expand all variables in the main section
	$self->_expand($Config::File::Section::MainSection)
		if $self->{_sections}->{$Config::File::Section::MainSection};

	foreach my $section (@{$self->{_sectorder}})
	{
		next if $section eq $Config::File::Section::MainSection;

        $self->_expand($section);
	}
}

sub expand { return shift->Expand(@_) };

#############################################################################
#
# the method to set or get an alias for a section
#
#  parameters:
#   $section     - the section the alias should be set for
#                  OR the alias that should be resolved
#   @aliases (o) - the alias name(s) of the section 
#     OR
#   $section - a hash with the sections and their alias(es)
#              {
#                   my_project => ['main', 'application'],
#                   database   => 'db',
#              }
#
#  returns:
#   the real section name if inspector call else the object itself
#
#  notes:
#
#############################################################################

sub SectionAlias
{
	my ($self, $section, @aliases) = @_;

    if (! ref($section) && $#aliases < 0)
    {
        return exists $self->{_section_aliases}->{$section} ?
               $self->{_section_aliases}->{$section} : $section;
    }

    unless (ref($section))
    {
        $section = { $section => \@aliases };
    }

    foreach my $sect (keys %$section)
    {
        if (ref($section->{$sect}))
        {
            $self->{_section_aliases}->{$_} = $sect
                foreach (@{$section->{$sect}});
        }
        else
        {
            $self->{_section_aliases}->{$section->{$sect}} = $sect;
        }
    }

	return $self;
}

sub section_alias { return shift->SectionAlias(@_) };

#############################################################################
#
# the method to check if a section exists
#
#  parameters:
#   $section - the name of the section to check
#
#  returns:
#   1 if the section exists else 0
#
#  notes:
#
#############################################################################

sub SectionExists
{
	my ($self, $section) = @_;

	$section = $self->SectionAlias($section);

	return exists $self->{_sections}->{$section};
}

sub section_exists { return shift->SectionExists(@_) };

#############################################################################
#
# the method to check if a variable exists
#
#  parameters:
#   $section  - the name of the section
#   $variable - the variable to check
#
#  returns:
#   1 if the variable exists else 0
#
#  notes:
#
#############################################################################

sub VariableExists
{
	my ($self, $section, $variable) = @_;

	$section = $self->SectionAlias($section);

	return $section
		   && $self->SectionExists($section)
		   && $variable
		   && $self->{_sections}->{$section}->VariableExists($variable);
}

sub variable_exists { return shift->VariableExists(@_) };

#############################################################################
#
# the accessor method for all sections
#
#  parameters:
#   none
#
#  returns:
#   a list of all sections in the order of the config file
#
#############################################################################

sub Sections
{
	my ($self) = @_;

	return @{$self->{_sectorder}};
}

sub sections { return shift->Sections(@_) };

#############################################################################
#
# the accessor method for sections
#
#  parameters:
#   $section - the section
#   $varhash - an optional reference of a hash with the new section
#              (variable => value pairs)
#
#  returns:
#   in case of wantarray the variable list of the section or a list of all 
#   section names if no section has been provided else the 
#   Config::File::Section
#
#  notes:
#   if the method is invoked as transformator function the changes will
#   only be made in the objects representation and written to disk at
#   destruction time unless the internal writing behaviour is unbuffered
#   (see method Buffered())
#
#############################################################################

sub Section
{
	my ($self, $section, $varhash) = @_;

	return @{$self->{_sectorder}} unless $section;

	return undef if (defined $varhash) && (ref($varhash) ne 'HASH');

	$section = $self->SectionAlias($section);

	unless (defined $self->{_sections}->{$section})
	{
		# let's create the section from scratch
		$self->{_changed} = 1;
		$self->{_sections}->{$section} = 
			new Config::File::Section($section);

		# store the section in the sectorder array
		push @{$self->{_sectorder}}, $section;

        return $self->{_sections}->{$section};
	}

    return $self->{_sections}->{$section} unless wantarray || defined $varhash;

	foreach my $var (keys %$varhash)
	{
		$self->Variable($section, $var, $varhash->{$var});
	}

	my @ret = @{$self->{_sections}->{$section}->{_varorder}};

	return @ret;
}

sub section { return shift->Section(@_) };

#############################################################################
#
# the method to include a section into another
#
#  parameters:
#   $section     - the section that should be extended
#   $inc_section - the section that should be included
#
#  returns:
#   a reference to the object itself for method call concatenations
#
#  notes:
#   changes will only be made in the objects representation and written to
#   disk at destruction time unless the internal writing behaviour is
#   unbuffered (see method Buffered())
#
#############################################################################

sub IncludeSection
{
    my ($self, $section, $inc_section) = @_;

    if ($self->SectionExists($inc_section))
    {
        $self->Section($section, $self->Section($inc_section)->AsHash());
        return $self;
    }

    return $self;
}

sub include_section { return shift->IncludeSection(@_) };

#############################################################################
#
# the method to remove a section
#
#  parameters:
#   $section - the section that should be removed
#
#  returns:
#   a reference to the object itself for method call concatenations
#
#  notes:
#   changes will only be made in the objects representation and written to
#   disk at destruction time unless the internal writing behaviour is
#   unbuffered (see method Buffered())
#
#############################################################################

sub RemoveSection
{
	my ($self, $section) = @_;

	return $self unless $$self->{_sections}->{$section};    # nothing to do

	$self->{_changed} = 1;
	delete $self->{_sections}->{$section};

	# remove the section from the sectorder array
	my $i = 0;
	$i++ while ($self->{_sectorder}[$i] ne $section);
	splice(@{$self->{_sectorder}}, $i, 1);

	$self->Write()
		if $self->{_options} & (WRITE_AUTOMATICALLY | ! BUFFERED);

	return $self;
}

sub remove_section { return shift->RemoveSection(@_) };

#############################################################################
#
# the accessor method for variables
#
#  parameters:
#   $section   - the section (if the section is missing || undef
#                Config::File::Section::DefaultSection will be used)
#   $variable  - the name of the variable
#   $value (o) - an new value or array of values of the variable;
#
#  returns:
#   the value(s) of the variable
#
#  notes:
#   if the method is invoked as transformator function the changes will
#   only be made in the objects representation and written to disk at
#   destruction time unless the internal writing behaviour is unbuffered
#   (see method Buffered())
#   in transformator mode the section will automatically be created if it
#   does not exist
#
#############################################################################

sub Variable
{
	my ($self, $section, $variable, $value) = @_;

	$section = $Config::File::Section::DefaultSection unless $section;

	$section = $self->SectionAlias($section);

	# create the section if it does not exist and a value is given
	$self->Section($section) 
		if ! defined($self->{_sections}->{$section}) && ($section ne $Config::File::Section::DefaultSection) && defined($variable) &&  defined($value) ;

	return undef unless defined $self->{_sections}->{$section};

    return $self->{_sections}->{$section}->AsHash() unless defined $variable;

	$self->{_changed} = defined $value;

	my @ret = $self->{_sections}->{$section}->Variable($variable, $value);

	$self->Write()
		if $self->{_changed}
		and ($self->{_options}->{MODE} & (WRITE_AUTOMATICALLY | ! BUFFERED));

	return wantarray ? @ret : $ret[0];
}

sub variable { return shift->Variable(@_) };
sub Variables { return shift->Variable($_[0], $_[1]) };
sub variables { return shift->Variable($_[0], $_[1]) };

#############################################################################
#
# the accessor method for the comment of a section or variable
#
#  parameters:
#   $section      - the section name
#   $variable (o) - the variable name
#
#  returns:
#   the comment of the section or the comment of the variable if given
#
#############################################################################

sub Comment
{
	my ($self, $section, $variable) = @_;

	$section = $self->SectionAlias($section);

	if (! $variable)
	{
		return $self->{_sections}->{$section}->Comment()
			if $self->{_sections}->{$section};
	}
	else
	{
		return $self->{_sections}->{$section}->{_variables}->{$variable}->Comment()
			if $self->{_sections}->{$section}->{_variables}->{$variable};
	}

	return undef;
}

sub comment { return shift->Comment(@_) };

#############################################################################
#
# the accessor method for the delimiters of a variable
#
#  parameters:
#   $section  - the section name
#   $variable - the variable name
#   $prefix   - the optional prefix delimiter
#   $suffix   - the optional suffix delimiters
#               (if only the prefix delimiter is given, the suffix is
#                assumed to be the same one)
#
#  returns:
#   an array with both delimiters
#
#############################################################################

sub Delimiters
{
	my ($self, $section, $variable, $prefix, $suffix) = @_;

	$section = $self->SectionAlias($section);

	return undef
		if ! $variable
		|| ! defined $self->{_sections}->{$section};

	return $self->{_sections}->{$section}
		->Delimiters($variable, $prefix, $suffix);
}

sub delimiters { return shift->Delimiters(@_) };

#############################################################################
#
# the method to read the configuration
#
#  parameters:
#   none
#
#  returns:
#   a reference to the object itself for function call concatenation
#
#############################################################################

sub Read
{
	my ($self) = @_;

	$self->{_readtime} = $self->GetModifyTime();

	if ($self->{_file})
	{
		open(FILE, $self->{_file});
		my $fh = \*FILE;

		if (defined $fh)
		{

			# throw away cached file
			$self->{_sections} = {};
			$self->{_parser}->File(join '', <$fh>);
			close($fh);
		}
	}

	# we reset the changed flag, because til now nothing has happened
	$self->{_changed} = 0;

	# as we now read the whole file we can expand variables (if required),
	# because we now don't depend on the order of the section and 
    # variable definitions
	$self->Expand() if $self->{_options}->{EXPAND};

	return $self;
}

sub read { return shift->Read(@_) };

#############################################################################
#
# the method to write the configuration
#
#  parameters:
#   none
#
#  returns:
#   a reference to the object itself for function call concatenation
#
#############################################################################

sub Write
{
	my ($self) = @_;

	if ($self->{_file})
	{
		open(FILE, "> $self->{_file}");
		my $fh = \*FILE;

		if ($fh)
		{
			my $oldstdout = select($fh);
			$| = 1;

			$self->Print();

			select($oldstdout);
			close($fh);
		}

	}

	$self->{_changed} = 0;

	return $self;
}

sub write { return shift->Write(@_) };

#############################################################################
#
# the method to print the configuration to STDOUT
#
#  parameters:
#   none
#
#  returns:
#   a reference to the object itself for function call concatenation
#
#  note:
#   this method should only be used for debugging purposes
#
#############################################################################

sub Print
{
	my ($self) = @_;

	if ($self->{_file})
	{
		foreach my $section (@{$self->{_sectorder}})
		{
			$self->{_sections}->{$section}->Write;
		}

	}

	return $self;
}

sub print { return shift->Print(@_) };

#############################################################################
#
# the method to retrieve the config file as hash
#
#  parameters:
#   none
#
#  returns:
#   the whole config file as hash
#
#  note:
#
#############################################################################

sub AsHash
{
	my ($self) = @_;

    my $res = {};

	if ($self->{_file})
	{
		foreach my $section (@{$self->{_sectorder}})
		{
			$res->{$section} = $self->Section($section)->AsHash();
		}

	}

	return $res;
}

sub as_hash { return shift->AsHash(@_) };

#############################################################################
#
# the method to write the config in a XML structur
#
#  parameters:
#   $xmldecl - flag to enforce xml declaration at the beginning
#              (default: 1)
#
#  returns:
#   a string containing the XML structur
#
#############################################################################

sub XML
{
	my ($self, $xmldecl) = @_;

	$xmldecl = 1 unless defined $xmldecl;

	my $xmlg = new XML::Generator(
								     conformance => 'strict',
									 escape      => 'always',
									 pretty      => 2,
									 encoding    => 'iso-8859-1'
	                             );

	my @xml;

	foreach my $section (@{$self->{_sectorder}})
	{
		push @xml, $self->{_sections}->{$section}->XML();
	}

	return ($xmldecl ? $xmlg->xmldecl(standalone => 'yes') : '') . 
	       $xmlg->config({ file => $self->{_file} }, @xml);
}

sub xml { return shift->Xml(@_) };

#############################################################################
#
# the accessor method for the name of the config file
#
#  parameters:
#   $file - an optional file name; if the file name is given, an open file
#           associated with this object will be saved and closed and the
#           new file will be opened and read
#
#  returns:
#   the (new) file name
#
#############################################################################

sub File
{
	my ($self, $file) = @_;

	if ($file && $file ne $self->{_file})
	{
		$self->Write()
			if $self->{_file}
			and $self->{_changed}
			and ($self->{_options} & WRITE_AUTOMATICALLY);

		$self->{_file} = $file;
		$self->Read;
	}

	return $self->{_file};
}

sub file { return shift->File(@_) };

################################################################################
#
# refresh this file: if changed write the config, then reread it
#
#  parameters:
#   none
#
#  returns:
#   nothing
#
################################################################################

sub Refresh
{
	my ($self) = @_;

	if ($self->{_changed})
	{
		$self->Write() if $self->{_options} & WRITE_AUTOMATICALLY;
	}
	else
	{
		$self->Read() if $self->GetModifyTime() > $self->{_readtime};
	}
}

sub refresh { return shift->Refresh(@_) };

################################################################################
#
# retrieve the last modifcation time of our file
#
#  parameters:
#   none
#
#  returns:
#   the modification time of course...
#
################################################################################

sub GetModifyTime()
{
	my ($self) = @_;

	my @stats = stat($self->{_file});
	return $stats[9];
}

sub get_modify_time { return shift->GetModifyTime(@_) };

#############################################################################
#
# returns all set options of a/all section
#
#  parameters:
#   $section - the section to get the options from else all sections are
#              queried
#
#  returns:
#   a list of options that are set; if no $section parameter is given the
#   option's names are prefixed by the section's name and a '_', e.g.
#   section_option
#
#############################################################################

sub Options
{
	my ($self, $section) = @_;

	$section = $self->SectionAlias($section);

	# the result array
	my @options;

	if ($section)
	{
		@options = $self->{_sections}->{$section}->Options();
	}
	else
	{
		foreach my $section (@{$self->{_sectorder}})
		{
			push @options,
				map { $_ = "${section}_$_" }
				$self->{_sections}->{$section}->Options();
		}
	}

	return @options;
}

sub options { return shift->Options(@_) };

#############################################################################
#
# helper method to expand variables
#
#  parameters:
#   $section  - the section
#   $variable - the variable that should be expanded
#
#  returns:
#   nothing
#
#############################################################################

sub _expand
{
	my ($self, $section, $variable) = @_;

    $section = $self->SectionAlias($section);

    return unless $self->SectionExists($section);

    unless ($variable)
    {
        # expand all variables in a section
        my @variables = $self->{_sections}->{$section}->Variables();

        $self->_expand($section, $_) foreach @variables;
    }

	my $value = $self->Variable($section, $variable);

	# substitute leading '~' with '$HOME'
	$value =~ s/^~/\$HOME/;

#    my $valre = qr/\$\{?([-:._\t\w()]+)\}?/;
    my $valre = qr/\$\{([-:._\t\w()]+)\}|\$([-:._\t\w()]+)?/;

	while ($value =~ /$valre/)
	{
		my $svar  = $1 // $2;
		my $sval  = undef;
        my $ssect = $section;

        if ($svar =~ /^([_\w]+)[\.:]([_\w]+)$/)
        {
            $ssect = $1;
            $svar  = $2;
        }

        # try the section variables first then the 'main' section
        if ($self->{_options}->{EXPAND} & EXPAND_VARS)
        {
            foreach my $sect ($ssect, $Config::File::Section::MainSection)
            {
                $sval = $self->Variable($sect, $svar);

                last if defined $sval;
            }
        }

        if (! defined($sval) && $self->{_options}->{EXPAND} & EXPAND_ENV)
        {
            # try the environment
            $sval = $ENV{$svar};
        }

		$sval = '' unless defined $sval;

		$value =~ s/$valre/$sval/;
	}

	# set the new value
	$self->Variable($section, $variable, $value);
}

#############################################################################
#
# shortcut methods
#
#  parameters:
#   handles the following calls
#     sections
#     <section>
#     <section>_variables
#     <section>_options
#     <section>_<variable>
#     <section>_<variable>(<new_value>)
#
#  returns:
#   the corresponding config file section or variable
#
#############################################################################

sub AUTOLOAD
{
	my $cmd = $AUTOLOAD;

	$cmd =~ m§(^.*)::([^:]+$)§;
	my $class = $1;
	$cmd = $2;
	return undef unless $class && $cmd;

    my $split_name = sub
    {
        my ($self, $name) = @_;

        my @nparts = split(/_/, $name);

        my $section_name = shift @nparts;

        my $section = $self->SectionAlias($section_name);

        while (! $self->SectionExists($section) && $#nparts >= 0)
        {
            $section_name .= '_' . shift @nparts;

            $section = $self->SectionAlias($section_name);
        }

        return ($section, $#nparts >= 0 ? join('_', @nparts) : undef);
    };

	my ($self, @params) = @_;

    my ($section, $variable) = &$split_name($self, $cmd);

	return $self->Section() 
        if $section =~ m§sections§i;

	return $self->Variable($section) 
        if $variable && $variable =~ m§variables§i;

	return $self->Variable($params[0]) 
        if $section =~ m§variables§i;
	
	return $self->Options($section) 
        if $variable && $variable =~ m§^options$§i;

    return undef unless $self->SectionExists($section);

    return $self->Section($section)
        unless defined $variable;

	return $self->Variable($section, $variable, @params);
}

#############################################################################
#
# the destructor
#
#  parameters:
#   none
#
#  returns:
#   nothing: or what do you expect
#
#############################################################################

sub DESTROY
{
	my ($self) = @_;

	$self->Write()
		if $self->{_changed}
		and ($self->{_options}->{MODE} & WRITE_AUTOMATICALLY);
}

# return a happy perl value
1;

__DATA__
<description>

This is the central class of the Config::File package, that reads,
manipulates and writes configuration files. Normally you deal only with
instances of this class after creating it or retrieving it from a
Config::File::Pool object.

<code>

    my $config = new Config::File("/some/file", 
                                  { 
                                      MODE    => CASE_SENSITIVE |
                                                 WRITE_AUTOMATICALLY |
                                                 BUFFERED, 
                                      EXPAND  => EXPAND_ALL,
                                      ALIASES => { homedir => 'home' }
                                  }
                                 );

    # get all options (i.e. flags, that can have the values 0 or 1)
    my @options = $config->options;

    # set the user variable in the session section
    $config->Variable('session', 'user', $user);
    $config->Write();

    # shortcuts
    $config->session_user($user);

    # get all sections
    my @sections = $config->sections();

    # get all variables and values of the section 'home'
    my %vars = $config->home_variables()
    # the same
    my %hvars = $config->Variables('home');

</code>

The configuration files can hold sections linke windows '.ini' files. All
variables without a section are assumed to belong to a default section
$Config::File::Section::DefaultSection ('global'). There's another
special section $Config::File::Section::Main ('main') that will be used 
during variable substitution (see below).

Sections are defined with brackets:

<code>

    [section]

</code>

The section ends at EOF or the next section definition.

Variables can be defined with any value that spans a single or multiple 
lines or just as options or flags with the possible values 0 or 1. Let's 
have an example:

<code>

    [mysection]
    commonvar = a value
    longvar   = 'a very long long ...
    long value'
    level     = 2
    # flags
    verbose   # set a flag
    +debug    # another way to set a flag
    -help     # disable help

</code>

Multi line values can be quoted by single or double quotes as well as
braces '{...}' or brackets '[...]'.

With the constructor option 'EXPAND' you can enforce variable substituion
in differnt ways. Possible values of 'EXPAND' are 'EXPAND_NONE' (the
default), 'EXPAND_VARS' to expand variables of the same or the magical
$Config::File::Section::Main (default: 'main') section, 'EXPAND_ENV' to
expand environment variables and 'EXPAND_ALL' (which is self-explanatory).

<code>

    [main]
    path = /usr/local
    ...

    [photos]
    ppath = ${path}/photos # expands to '/usr/local/photos'

    [homes]
    jeff = $HOME # expands to '/home/jeff'
    hugo = ~     # expands to '/home/hugo'

</code>

By default variable names are handled case insensitive. If you need case
sensitive variable names use the value CASE_SENSITIVE for the constuctor
option 'MODE'. Additionally you can enforce the constructed object to write
the configuration file after any change by adding (logical OR)
WRITE_AUTOMATICALLY to the 'MODE'. By default the file will only be
written at destruction time ('BUFFERED' mode).

All sections and variables can be accessed or modified by the methods
Section() and Variable() (see below). For lazy engineers there are - thanks
AUTOLOAD - several shortcuts. So you can access each section also by name
and each variable with the section's and variable's name connected by a
underscore:

<code>

    # section inspector calls
    $config->mysection();
    # or
    $config->mysection;

    # variable inspector calls
    $config->mysection_myvariable();
    # or
    $config->mysection_myvariable;

    # section transformator call
    $config->mysection(%newvars);

    # variable transformator call
    $config->mysection_myvariable($newvalue);

    # get all options (flags)
    $config->options();

    # get all options of a particular section
    $config->mysection_options();

</code>

At last, if you don't like the builtin Parse::RecDescent grammar you can
provide the constructor your own one.

</description>
