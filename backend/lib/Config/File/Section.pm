#############################################################################
#
# Copyright (c) by jeff (jeff@lipsia.de)
#
# Author:  jeff
#
# File:    $Id: Section.pm,v 1.9 2018/04/25 09:41:55 jeff Exp $
#
# Purpose: the class that represents a section of a config file
#
# Created: 98/12/22
#
# Update:  $Date: 2018/04/25 09:41:55 $
#
# Notes:
#
#############################################################################

package Config::File::Section;
require 5.6.1;

use Config::File::Variable;

use XML::Generator qw(:pretty);

use strict;
use vars qw($VERSION $AUTOLOAD $DefaultClass $DefaultSection $MainSection $Prefix $Suffix @ISA);

($VERSION = '$Revision: 1.9 $') =~ s/^\$Revision[:]\s*|\s*\$$//g;

$Prefix = '[';
$Suffix = ']';

$DefaultClass = 'Config::File::Section' 
	unless defined $Config::File::Section::DefaultClass;

$DefaultSection = 'global';
$MainSection    = 'main';

#############################################################################
#
# the constructor
#
#  parameters:
#   $name - the name of the section; if the name is missing the
#           DefaultSection will be used
#
#  returns:
#   the new instance of the class
#
#############################################################################

sub new
{
	my ($class, $name) = @_;

	$name = $DefaultSection if ! $name;

	my $self = {};

	bless $self, ref $class || $class || $DefaultClass;
	$self->{_name}       = $name;
	$self->{_max_varlen} = 0;

	return $self;
}

#############################################################################
#
# the method to check if a variable exists
#
#  parameters:
#   $variable - the name of the variable to check
#
#  returns:
#   1 if the variable exists else 0
#  notes:
#
#############################################################################

sub VariableExists
{
	my ($self, $variable) = @_;

	return exists $self->{_variables}->{$variable};
}

sub variable_exists { return shift->VariableExists(@_) };

#############################################################################
#
# inspector method to retrieve the section as hash
#
#  parameters:
#   $instructions: instructions for the variables (e.g. 'wantarray')
#                  {
#                      '<myvar>' => 'wantarray',
#                  }
#
#  returns:
#   the complete section as a hash
#  notes:
#
#############################################################################

sub AsHash
{
	my ($self, $instructions) = @_;

    my $hash = {};

    foreach my $var (@{$self->{_varorder}})
    {
        my @values = $self->{_variables}->{$var}->Value();

        $hash->{$var} = ($#values > 0 || $instructions->{$var} && $instructions->{$var} eq 'wantarray') ?
                        \@values : $values[0];
    }

	return $hash;
}

sub as_hash { return shift->AsHash(@_); }

#############################################################################
#
# the accessor method for all variables
#
#  parameters:
#   none
#
#  returns:
#   a list of all variables in this section
#
#  notes:
#
#############################################################################

sub Variables
{
	my ($self) = @_;

    return sort keys %{$self->{_variables}};
}

sub variables { return shift->Variables(@_) };

#############################################################################
#
# the accessor method for variables
#
#  parameters:
#   $variable - the name of the variable
#   $value    - an optional new value of the variable; the value can be a
#               scalar or a reference to an array; if a value is given it
#               replaces the old value of the variable unless the value name
#               has a '+' as prefix
#
#  returns:
#   the value(s) of the variable or a list of all variables if no
#   variable name has been given
#
#  notes:
#   if the method is invoked as transformator function the changes will
#   only be made in the objects representation and written to disk at
#   destruction time unless the internal writing behaviour is unbuffered
#   (see method Buffered())
#
#############################################################################

sub Variable
{
	my ($self, $variable, $value) = @_;

	unless ($variable)
	{
		# the caller want's to have a list of all variables
		return sort keys %{$self->{_variables}};
	}

	my $add = 0;

	if (substr($variable, 0, 1) eq '+')
	{
		$variable = substr($variable, 1, length($variable) - 1);
		$add = 1;
	}

	# store variable order if variable is not defined and the caller
	# is a Parse::RecDescent method
	my @caller = caller(1);
	push @{$self->{_varorder}}, $variable
		if ! defined $self->{_variables}->{$variable}
		and $caller[0] =~ /Parse::RecDescent/;

	my @ret =
		defined $self->{_variables}->{$variable}
		? $self->{_variables}->{$variable}->Value
		: ();

	if (defined $value)
	{
		unless ($self->{_variables}->{$variable})
		{
			$self->{_variables}->{$variable} = 
				new Config::File::Variable($variable);

			# store the maximum variable length for write alignments
			my $len = length($variable);
			$self->{_max_varlen} = $len if $len > $self->{_max_varlen};

			# store the variable's name in the varorder array if neccessary
			push @{$self->{_varorder}}, $variable
				if $caller[0] !~ /Parse::RecDescent/;
		}
		@ret = $add
			? $self->{_variables}->{$variable}->AddValues($value)
			: $self->{_variables}->{$variable}->Value($value);
	}

	return wantarray ? @ret : $ret[0];
}

sub variable { return shift->Variable(@_) };

#############################################################################
#
# the accessor method for the delimiters of a variable
#
#  parameters:
#   $variable - the variable name
#   $prefix   - the optional prefix delimiter
#   $suffix   - the optional suffix delimiter
#               (if only the prefix delimiter is given, the suffix is
#                assumed to be the same one)
#
#  returns:
#   an array with both delimiters
#
#############################################################################

sub Delimiters
{
	my ($self, $variable, $prefix, $suffix) = @_;

	return undef
		if ! $variable
		|| ! defined $self->{_variables}->{$variable};

	return $self->{_variables}->{$variable}->Delimiters($prefix, $suffix);
}

sub delimiters { return shift->Delimiters(@_) };

#############################################################################
#
# the method to write the section
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

	# print at first the comment if any
	my $comment = $self->{_comment};
	if ($comment)
	{
		# add a comment ('#') character before each line
		$comment =~ s§\n§\n# §gs;
		$comment = "# $comment";
		print "$comment\n";
	}

	print $Prefix, $self->{_name}, $Suffix, "\n"
		if $self->{_name} ne $DefaultSection;

	foreach my $variable (@{$self->{_varorder}})
	{
		$self->{_variables}->{$variable}->Write($self->{_max_varlen});
	}

	# we add an empty line for readability!
	print "\n";

	return $self;
}

sub write { return shift->Write(@_) };

#############################################################################
#
# the method to write the section's config in a XML structur
#
#  parameters:
#   none
#
#  returns:
#   a string containing the XML structur
#
#############################################################################

sub XML
{
	my ($self) = @_;

	my $xmlg = new XML::Generator(
	                                 conformance => 'strict',
									 escape      => 'always',
									 pretty      => 2,
									 encoding    => 'iso-8859-1'
								 );

	my @xml = ();
	my $chash = { name => $self->{_name} };
	$chash->{comment} = $self->{_comment} if $self->{_comment};

	foreach my $variable (@{$self->{_varorder}})
	{
		push @xml, $self->{_variables}->{$variable}->XML();
	}

	return $xmlg->section($chash, @xml);
}

sub xml { return shift->XML(@_) };

#############################################################################
#
# accessor method for the section's comment
#
#  parameters:
#   $comment (o) - the new comment
#
#  returns:
#   the (new) comment of the section
#
#############################################################################

sub Comment
{
	my ($self, $comment) = @_;

	$self->{_comment} = $comment if $comment;

	return $self->{_comment};
}

sub comment { return shift->Comment(@_) };

#############################################################################
#
# returns all set options
#
#  parameters:
#   none
#
#  returns:
#   a list of options that are set
#
#############################################################################

sub Options
{
	my ($self) = @_;

	# the result array
	my @options;

	foreach my $variable (@{$self->{_varorder}})
	{

		# avoid calling Config::File::Variable::IsOption twice
		my $val = $self->{_variables}->{$variable}->OptionValue();
		push @options, $variable if $val;
	}

	return @options;
}

sub options { return shift->Options(@_) };

#############################################################################
#
# shortcut method
#
#  parameters:
#   variable - the name of the variable
#
#  returns:
#   the corresponding config file variable
#
#############################################################################

sub AUTOLOAD
{
	my $variable = $AUTOLOAD;

	$variable =~ s/.*:://;

    my $self = shift;

    return unless defined $self->{_variables};

    return $self->Variable($variable, @_);
}

# return a happy perl value
1;

__DATA__
<description>

Nothing to tell much about this class, because it is only a helper for 
Config::File to deal with sections. So, as you never come up with it, have
a look at the documentation of Config::File.

</description>
