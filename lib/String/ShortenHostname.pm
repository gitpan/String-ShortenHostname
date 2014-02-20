use strict;
use warnings;
package String::ShortenHostname;

our $VERSION = '0.001'; # VERSION

use Moose;

has 'length' => ( is => 'rw', isa => 'Int', required => 1 );
has 'keep_digits_per_domain' => ( is => 'rw', isa => 'Int', default => 3 );

has 'force' => ( is => 'rw', isa => 'Bool', default => 0 );
has 'force_edge' => ( is => 'rw', isa => 'Maybe[Str]');

sub shorten {
	my ( $self, $hostname ) = @_;
	my $cur_len = length($hostname);
	my ( $host, @domain ) = split('\.', $hostname);

	if( $cur_len <= $self->length ) {
		return($hostname); # already short
	}

	for( my $i = scalar(@domain) - 1 ; $i >= 0 ; $i--) {
		$domain[$i] = substr($domain[$i], 0, $self->keep_digits_per_domain);
		$cur_len = length(join('.', $host, @domain));
		
		if( $cur_len <= $self->length ) {
			return( join('.', $host, @domain) );
		}
	}

	$hostname = join('.', $host, @domain);

	if( $self->force ) {
		$hostname = substr($hostname, 0, $self->length);
		if( defined $self->force_edge ) {
			$hostname = substr($hostname, 0, $self->length - length($self->force_edge));
			$hostname .= $self->force_edge;
		}
	}

	return($hostname);
}

1;

__END__

=head1 NAME

String::ShortenHostname - tries to shorten hostnames while keeping them meaningful

=head1 SYNOPSIS

  use String::ShortenHostname;

  $sh = String::ShortenHostname->new( length => 20, keep_digits_per_domain => 3 );
  $sh->shorten('zumsel.haushaltswarenabteilung.einzelhandel.de');
  # zumsel.hau.ein.de
  $sh->keep_digits_per_domain(5);
  $sh->shorten('zumsel.haushaltswarenabteilung.einzelhandel.de');
  # zumsel.haush.einze.de

  $sh->keep_digits_per_domain(3);
  $sh->shorten('verylonghostnamepartcannotbeshortend.some-domain.de');
  # verylonghostnamepartcannotbeshortend.som.de -> still 43 chars 

  $sh->force(1);
  $sh->shorten('verylonghostnamepartcannotbeshortend.some-domain.de');
  # verylonghostnamepart

  $sh->force_edge('~');
  $sh->shorten('verylonghostnamepartcannotbeshortend.some-domain.de');
  # verylonghostnamepar~

=head1 DESCRIPTION

String::ShortenHostname will try to shorten the hostname string to the length specified.
It will cut each domain part to a given length from right to left till the string is
short enough or the end of the domain has been reached.

Options:

=over

=item length (required)

The desired maximum length of the hostname string.

=item keep_digits_per_domain (default: 3)

Cut each domain part at this length.

=item force (default: 0)

If specified the module will force the length by cutting the result string.

=item force_edge (default: undef)

If defined this string will be used to replace the end of the string to
indicate that it was truncated.

=back

=head1 COPYRIGHT

Copyright 2014 Markus Benning <me@w3r3wolf.de>

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
