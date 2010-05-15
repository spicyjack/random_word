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
# local modules
use lib qw( ../lib );
use Random::Word;

# begin
    # filename of the wordlist to use, or '-' for STDIN
    my $input_file;
    # number of words to quiz with
    my $num_of_words = 1;
    # are we debugging?
    my $DEBUG = 0;
    my $parser = Getopt::Long::Parser->new();
    $parser->getoptions(
        q(inputfile|filename|f=s) => \$input_file,
        q(number|n=i) => \$num_of_words,
        q(debug|d) => \$DEBUG,
    ); # $parser->getoptions
    
    warn qq(DEBUG is $DEBUG\n);
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

    # slurp up all of the lines from the filehandle
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
    for ( my $x = 1; $x <= $num_of_words; $x++ ) {
        # grab a random word object out of the word_objs array
        my $random_word = $word_objs[int(rand(scalar(@word_objs)))];
        print qq(=-= Try #$x out of $num_of_words =-=\n);
        print qq(Guess the word based on the definition....\n);
        print $random_word->get_definition() . q(: );
        # use the diamond operator to read in user input
        binmode STDIN, ":utf8";
        my $answer = <>;
        chomp($answer);
        if ( $answer eq $random_word->get_word() ) {
            print qq(Correct! $answer = ) . $random_word->get_definition() 
                . qq(\n);
        } else {
            print qq(Incorrect! ) . $random_word->get_word() . q( = ) 
                . $random_word->get_definition() . qq(\n);
            if ( $DEBUG == 1 ) {
                my @debug_words = ( $random_word->get_word(), $answer );
                foreach my $word_to_split ( @debug_words ){
                    my @word = split( //, $word_to_split );
                    my $hexword = q();
                    foreach my $letter ( @word ) {
                        $hexword .= sprintf(q(0x%0x), ord($letter)) . q( );
                    } # foreach my $letter ( @word )
                    print $word_to_split . qq(: $hexword\n);
                } # foreach my $word_to_split
            } # if ( $DEBUG ) 
        } # if ( $answer eq $word )
    } # for ( my $x = 1; $x == $num_of_words; $x++ )

# fin!
