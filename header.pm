package mqs::header;

use 5.006;
use strict;
use warnings;

require Exporter;
require DynaLoader;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use mqs::header ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
		read_header
		add_header
		read_content
	
);
our $VERSION = '0.01';

bootstrap mqs::header $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.


sub read_header
{
	my $content = $_[0];
	my @content = split(/\n/,$content);
	my $i;
	my $cond = 1;
	my %header;
	my @tmp;
	$header{'mqs-header'} = "no";
	for($i = 0; $cond == 1 && $i < $#content; $i++)
	{
		if($content[$i] eq "")
		{
			$cond = -1;
		}
		if($cond != -1)
		{	
			@tmp = split(/\:\ /,$content[$i]);
			$header{$tmp[0]} = $tmp[1];
		}
	}
	return %header;
}

sub add_header
{
	my $content = $_[0];
	my $key = $_[1];
	my $value = $_[2];
	my %header = read_header($content);
	if($header{'mqs-header'} eq "no")
	{
		$content = "mqs-header: yes\n\n".$content;
	}
	$content = $key.": ".$value."\n".$content;
	return $content;
}

sub read_content
{
	my $content = $_[0];
	my %header = read_header($content);
	if($header{'mqs-header'} eq "no")
	{
		return $content;
	}
	my @content = split(/\n/,$content);
	my $return = "";
	my $cond = -1;
	my $i;
	for($i = 0; $i <= $#content; $i++)
	{
		if($content[$i] eq "")
		{
			$cond = 1;
		}
		if($cond == 1 && $content[$i] ne "")
		{
			$return = $return.$content[$i]."\n";
		}
	}
	return $return;
}



1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

mqs::header - Perl extension for header management of files, to use
with mqs::spool module

=head1 SYNOPSIS

  use mqs::header;

%header read_header($content)

$content add_header($content,$key,$value)

$content read_content($content)

=head1 DESCRIPTION

mqs::spool manage headers in messages or in simple scalar, when you add
a new value in the header of a scalar, the first values given to the
header is mqs-header: yes this value determines the fact that the scalar
has an header.

read_header returns a hash wich keys and values in the header, if no
header is included in $content, the hash contains only mqs-header: no.

add_header adds a key: value in the header and create the header if it
does not exist

read_content returns the content of all the scalar without the header.

=head2 EXPORT

add_header
read_header
read_content

=head1 AUTHOR

Stehane TOUGARD elair@darea.fr

=head1 SEE ALSO

L<perl>.

=cut
