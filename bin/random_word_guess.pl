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
    if ( defined $input_file ) {
        $INFD = IO::File->new(qq( < $input_file));
    } else {
        $INFD = IO::Handle->new_from_fd(fileno(STDIN), q(<));
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
        print qq(Guess the word based on the definition....\n);
        print $random_word->get_definition() . q(: );
        # use the diamond operator to read in user input
        my $answer = <>;
        chomp($answer);
        if ( $answer eq $random_word->get_word() ) {
            print qq(Correct! $answer = ) . $random_word->get_definition() 
                . qq(\n);
        } else {
            print qq(Incorrect! ) . $random_word->get_word() . q( = ) 
                . $random_word->get_definition() . qq(\n);
        } # if ( $answer eq $word )
    } # for ( my $x = 1; $x == $num_of_words; $x++ )

# fin!
