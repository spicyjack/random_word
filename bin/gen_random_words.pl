#!/usr/bin/perl -w

# random_words.pl

# read a text file full of words and their definitions, separated by a comma,
# then choose a random number of words based on the user's input

# notes:
# http://ahinea.com/en/tech/perl-unicode-struggle.html

package main;

use strict;
use warnings;
# system modules
use Encode;
use Getopt::Long;
use IO::File;
# local module
use Random::Word;
use lib q(../lib);

# begin
    my $input_file;
    my $num_of_words = 1;
    my $parser = Getopt::Long::Parser->new();
    $parser->getoptions(
        q(inputfile|filename|f=s) => \$input_file,
        q(number|n=i) => \$num_of_words,
    ); # $parser->getoptions
    
    my $INFD;
    # set UTF-8 on STDOUT to keep perl from bitching
    binmode STDOUT, ":utf8";
    if ( defined $input_file && $input_file ne q(-)) {
        $INFD = IO::File->new(qq( < $input_file));
    } elsif ( defined $input_file && $input_file eq q(-)) {
        $INFD = IO::Handle->new_from_fd(fileno(STDIN), q(<));
    } else {
        die qq(ERROR: please define an input file with --inputfile);
    } # if ( length($parsed{input}) > 0 )
    my @lines=<$INFD>;
    my $counter = 0;

    # a list of word objects
    my @word_objs;
    foreach my $line (@lines) {
        # skip commented lines
        next if ( $line =~ /^#/ );
        chomp($line);
        #print $line . qq(\n);
        my $decoded_line = decode_utf8($line);
        my @words = split(q(,), $decoded_line);
        push(@word_objs, Random::Word->new(@words));
    } # foreach my $line (@lines)

    # loop as many times as was requested
    for ( my $x = 1; $x == $num_of_words; $x++ ) {
        # grab a random word object out of the word_objs array
        my $random_word = $word_objs[int(rand(scalar(@word_objs)))];
        # FIXME slice the word object out of the array so it can't be reused
        # use the diamond operator to read in user input
        print q(random word: ) . $random_word->get_word() . qq(\n);
    } # for ( my $x = 1; $x == $num_of_words; $x++ )

# fin!
