#############################################################################
#
# Copyright (c) by jeff (jeff@lipsia.de)
#
# Author:  jeff
#
# File:    $Id: Variable.pm,v 1.7 2018/04/25 09:41:55 jeff Exp $
#
# Purpose: the class that represents a variable of a config file
#
# Created: 98/12/22
#
# Update:  $Date: 2018/04/25 09:41:55 $
#
# Notes:
#
#############################################################################

package Config::File::Variable;
require 5.6.1;

use strict;
use vars qw($VERSION $DefaultClass $EqualSign @ISA);

use XML::Generator qw(:pretty);

($VERSION = '$Revision: 1.7 $') =~ s/^\$Revision[:]\s*|\s*\$$//g;

$EqualSign = '=';

$DefaultClass = 'Config::File::Variable'
	unless defined $Config::File::Variable::DefaultClass;

#############################################################################
#
# the constructor
#
#  parameters:
#   $name - the name of the variable
#
#  returns:
#   the new instance of the class
#
#############################################################################

sub new
{
	my ($class, $name) = @_;

	return undef if ! $name;

	my $self = {};

	bless $self, ref $class || $class || $DefaultClass;
	$self->{_name}      = $name;
	$self->{_equalsign} = $EqualSign;
	$self->{_prefix}    = '';
	$self->{_suffix}    = '';

	return $self;
}

#############################################################################
#
# the method to add (append!) values
#
#  parameters:
#   $values - a reference to an array of values or a scalar value
#
#  returns:
#   the value(s) of the variable
#
#  notes:
#   if the method is called in array context an array with all (maybe
#   with only one cell filled) will be returned else only the first
#   value
#
#############################################################################

sub AddValues
{
	my ($self, $values) = @_;

	if (defined $values)
	{
		@{$self->{_values}} = () if ! defined $self->{_values};

		if (ref(\$values) eq 'SCALAR')
		{
			push @{$self->{_values}}, $values;
		}
		elsif (ref($values) eq 'SCALAR')
		{
			push @{$self->{_values}}, $$values;
		}
		elsif (ref($values) eq 'ARRAY')
		{
			push @{$self->{_values}}, @$values;
		}
	}

	return wantarray ? @{$self->{_values}} : $self->{_values}->[0];
}

sub add_values { return shift->AddValues(@_) };

#############################################################################
#
# the accessor method for the value(s)
#
#  parameters:
#   $values - an optional reference to an array of values or a scalar value
#
#  returns:
#   the value(s) of the variable
#
#  notes:
#   if the method is called in array context an array with all (maybe
#   with only one cell filled) will be returned else only the first
#   value
#
#############################################################################

sub Value
{
	my ($self, $values) = @_;

	@{$self->{_values}} = () if defined $values;

	$self->AddValues($values);

	return wantarray ? @{$self->{_values}} : $self->{_values}->[0];
}

sub value { return shift->Value(@_) };

#############################################################################
#
# check wether the variable is a option/flag or not
#
#  parameters:
#   none
#
#  returns:
#   1 if the variable is a option/flag or not
#
#  note:
#   the return value says nothing about the value of the variable!
#
#############################################################################

sub IsOption
{
	my ($self) = @_;

	return $#{$self->{_values}} == 0 &&
           $self->{_values}->[0] =~ /^(0|1|true|false|on|off)$/;
}

sub is_option { return shift->IsOption(@_) };

#############################################################################
#
# inspector method for a option's/flag's value
#
#  parameters:
#   none
#
#  returns:
#   1 if the option/flag is set else 0; if the variable isn't a option/flag
#   undef is returned
#
#############################################################################

sub OptionValue
{
	my ($self) = @_;

	return $self->IsOption() 
           ? $self->{_values}->[0] =~ /^(1|true|on)$/
             ? 1
             : 0
           : undef;
}

sub option_value { return shift->OptionValue(@_) };

#############################################################################
#
# the method to set optional delimiters (quotes or braces etc.)
#
#  parameters:
#   $prefix - an optional prefix string
#   $suffix - an optional suffix string
#
#  returns:
#   an array containing the prefix and the suffix string
#
#############################################################################

sub Delimiters
{
	my ($self, $prefix, $suffix) = @_;

	$self->{_prefix} = $prefix if $prefix;
	$suffix          = $prefix if ! $suffix;
	$self->{_suffix} = $suffix if $suffix;

	return ($self->{_prefix}, $self->{_suffix});
}

sub delimiters { return shift->Delimiters(@_) };

#############################################################################
#
# the method to override the default equal sign ('=')
#
#  parameters:
#   $equalsign - an optional new equal sign
#
#  returns:
#   an array containing the prefix and the suffix string
#
#############################################################################

sub EqualSign
{
	my ($self, $equalsign) = @_;

	$self->{_equalsign} = $equalsign if ! $equalsign;

	return $self->{_equalsign};
}

sub equal_sign { return shift->EqualSign(@_) };

#############################################################################
#
# the method to write the variable
#
#  parameters:
#   $max_len - the maximum length of variables in the section this variable
#              belongs to
#
#  returns:
#   a reference to the object itself for function call concatenation
#
#############################################################################

sub Write
{
	my ($self, $max_len) = @_;

	# print at first the comment if any
	my $comment = $self->{_comment};
	if ($comment)
	{
		# add a comment ('#') character before each line
		$comment =~ s§\n§\n# §gs;
		$comment = "# $comment";
		print "$comment\n";
	}


	my $spaces = " " x ($max_len + 2 - length($self->{_name}));

	foreach my $value (@{$self->{_values}})
	{
	    print "$self->{_name}${spaces}$self->{_equalsign}  ";

		print $self->{_prefix}, $value, $self->{_suffix}, "\n";
	}

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

	my $chash = { name => $self->{_name} };
	$chash->{comment} = $self->{_comment} if $self->{_comment};
	my @vals  = ();

	foreach my $value (@{$self->{_values}})
	{
		push @vals, $self->{_prefix} . $value . $self->{_suffix};
	}

	return $xmlg->variable($chash, join('', @vals));
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


# return a happy perl value
1;

__DATA__
<description>

Nothing to tell much about this class either, because it is only a helper 
for Config::File to deal with sections. So, as you never come up with it, 
have a look at the documentation of Config::File.

</description>
