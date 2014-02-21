package String::ShortenHostname::App;

use Moose;
use IO::Handle;

our $VERSION = '0.003'; # VERSION

extends 'String::ShortenHostname';
with 'MooseX::Getopt';

has '+length' => (
	traits => ['Getopt'],
	cmd_aliases => "l",
	documentation => "the desired length of the hostname string",
);

has '+keep_digits_per_domain' => (
	traits => ['Getopt'],
	cmd_aliases => "d",
	documentation => "number of digits per domain",
);

has '+domain_edge' => (
	isa => 'Str',
	traits => ['Getopt'],
	cmd_aliases => "e",
	documentation => "edge string for truncation of domain",
);

has '+cut_middle' => (
	traits => ['Getopt'],
	cmd_aliases => "m",
	documentation => "dont truncate, cut in the middle of domain",
);

has '+force' => (
	traits => ['Getopt'],
	cmd_aliases => "f",
	documentation => "force string length (truncate)",
);

has '+force_edge' => (
	isa => 'Str',
	traits => ['Getopt'],
	cmd_aliases => "E",
	documentation => "edge string for forced truncation of string",
);

sub run {
	my $self = shift;

	if( @{$self->extra_argv} ) {
		foreach my $hostname ( @{$self->extra_argv} ) {
			print $self->shorten($hostname)."\n";
		}
		return;
	}
	
	my $stdin = IO::Handle->new_from_fd(fileno(STDIN),"r")
		or die('cant open STDIN: '.$@);
	while( my $line = $stdin->getline ) {
		chomp($line);
		print $self->shorten($line)."\n";
	}
	$stdin->close;

	return;
}

1;

