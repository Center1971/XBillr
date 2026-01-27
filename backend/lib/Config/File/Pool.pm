#############################################################################
#
# Copyright (c) by jeff (jeff@lipsia.de)
#
# Author:  jeff
#
# File:    $Id: Pool.pm,v 1.7 2006/11/30 21:15:54 jeff Exp $
#
# Purpose: a class to handle a pool of config files
#
# Created: 98/12/22
#
# Update:  $Date: 2006/11/30 21:15:54 $
#
# Notes:   there's only one instance of this class; each constructor call
#          returns the same object; this ensures that all callers talk to
#          the same config file object and read and write the same config
#          file
#
#############################################################################

package Config::File::Pool;
require 5.6.1;

use strict;
no strict 'refs';
no strict 'subs';
use vars qw($VERSION $DefaultClass @Extensions @ISA);

use Config::File;

($VERSION = '$Revision: 1.7 $') =~ s/^\$Revision[:]\s*|\s*\$$//g;

$DefaultClass = 'Config::File::Pool' 
	unless defined $Config::File::Pool::DefaultClass;

@Extensions = ('', '.conf', '.cfg', '.ini');

#############################################################################
# 
# the constructor
#
#  parameters:
#   $root - the optional Root directory; all file names given without 
#           absolute path will be prefixed with $root
#
#  returns:
#   the only instance of this class
#
#############################################################################

sub new
{
	my ($class, $root) = @_;

	$class = $DefaultClass if ! $class;

	my $self = {};

	if (${"${class}::_instance"} && ref(${"${class}::_instance"}))
	{
		# our unique instance still exists, so we simply reuse it
		$self = ${"${class}::_instance"};
	}
	else
	{
		# it's the first call of the constructor, so we store
		# the object reference in our instance variable
		${"${class}::_instance"} = $self;
		bless $self, ref $class || $class || $DefaultClass;
		$self->Root($root ? $root : $ENV{'CONFIG_ROOT'}) ;
	}

	return $self;
}

#############################################################################
# 
# the accessor method for the Root directory
#
#  parameters:
#   $root - the optional new Root directory
#
#  returns:
#   the (new) value of the Root directory
#
#############################################################################

sub Root
{
	my ($self, $root) = @_;

	if ($root)
	{
		$root .= '/' unless $root =~ m§/$§;
		$self->{_root} = $root;
	}

	return $self->{_root};
}

sub root { return shift->Root(@_) };

#############################################################################
# 
# the accessor method for a config file object
#
#  parameters:
#   $file    - the name/subpath of the config file relative to Root 
#              if the config file object does not exist, a new one will be 
#              created with the file name
#   $grammar - an optional grammar;
#
#  returns:
#   the config file object if successful else undef
#
#############################################################################

sub File
{
	my ($self, $file, $grammar) = @_;

	# make a long story short
	return $self->{_files}->{$file} if defined $self->{_files}->{$file};

	my $i = 0;
	while (! defined $self->{_files}->{$file})
	{
		return undef if $i > $#Extensions;
		my $fname = $file . $Extensions[$i++];
		unless (-e $fname)
		{
			$fname = $self->{_root} . $fname;
			next unless -e $fname;
		}

		$self->{_files}->{$file} =
			new Config::File($fname, $grammar);
	}

	unless (defined $self->{_files}->{$file})
	{
		# hmm, file still not found -> let's create it
		$self->{_files}->{$file} =
			new Config::File($file =~ m§^/§ ? $file : $self->{_root} . $file,
			                 $grammar);
	}

	return $self->{_files}->{$file};
}

sub file { return shift->File(@_) };

#############################################################################
# 
# the method to re-read some or all files from disk
#
#  parameters:
#   @fnames - a string with the file to re-read or an array of strings with 
#             the files to re-read or none; if no file name is provided all 
#             files will be refreshed
#
#  returns:
#   the reference to the pool object itself
#
#############################################################################

sub Refresh
{
	my ($self, @fnames) = @_;

	@fnames = keys %{$self->{_files}} unless $#fnames > -1;

	foreach my $file (@fnames)
	{
		$self->{_files}->{$file}->Refresh() ;
	}

	return $self ;
}

sub refresh { return shift->Refresh(@_) };

#############################################################################
# 
# the destructor
#
#  parameters:
#   none
#
#  returns:
#   nothing, or what do you expect?
#
#  note:
#   
#
#############################################################################

sub DESTROY
{
	my ($self) = @_;

	foreach my $file (keys %{$self->{_files}})
	{
		$self->{_files}->{$file}->Write 
			if $self->{_files}->{$file} and
			   $self->{_files}->{$file}->Options() & WRITE_AUTOMATICALLY;
	}
}

# return a happy perl value
1;

__DATA__
<description>

An object instantiated from this class - and there's only one single
object per application - can be used as a pool of configuration files
of type Config::File.

<code>

    my $cpool = new Config::File::Pool('/application/config');

    my $config1 = $cpool->File('app1.conf');
    my $config2 = $cpool->File('app2.conf');

</code>

So, why to use this class? The answer is, it prevents an application - or
better: an application server - to reread configuration files at any time
the configuration file is needed, e.g. an application is reincarnated.

</description>
