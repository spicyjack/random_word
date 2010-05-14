package Random::Word;

use warnings;
use strict;

=head1 NAME

Random::Word - An object that holds a word and it's definition.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Holds a word and it's definition.  Can also hold imperfective/perfective pairs
for languages that have those types of constructs.

    use Random::Word;

    my $foo = Random::Word->new();
    ...

=head1 FUNCTIONS

=head2 new(@words)

Creates a new L<Random::Word> object, and parses out the word and it's
definition in order to populate the object.

=cut

sub new {
    my $class = shift;
    my @words = @_;

    my $self;

    if ( scalar(@words) == 2 ) {
        # only two elements, assign it to word and definition
        my ($word, $definition) = @words;
        $self = bless({
            _word => $words[0],
            _definition => $words[1]
        }); # $self = bless
    } else {
        $self = bless({
            _imperfective => $words[0],
            _word => $words[0],
            _perfective => $words[1],
            _definition =>  join(q(,), @words),
        }); # $self = bless
    } # if ( scalar(@words) == 2 )
    return $self;
} # sub new

=head2 get_word()

Returns the current word.

=cut

sub get_word {
    my $self = shift;
    return $self->{_word};
} # sub get_word

=head2 get_word()

Returns the current definition

=cut

sub get_definition {
    my $self = shift;
    return $self->{_definition};
} # sub get_word

=head1 AUTHOR

Brian Manning, C<< <elspicyjack at gmail dot com> >>

=head1 BUGS

Please report any bugs or feature requests to the author.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Random::Word

=head1 COPYRIGHT & LICENSE

Copyright 2010 Brian Manning, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Random::Word
