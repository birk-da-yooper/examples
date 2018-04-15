#!/usr/bin/perl
use warnings;
use strict;

=head1 DESCRIPTION

Write a program that prints the numbers from 1 to 100. But for multiples of three print "Fizz"
instead of the number and for the multiples of five print "Buzz". For numbers which are multiples of
both three and five print "FizzBuzz".

=cut

my %bound = ('start' => 1, 'end' => 100);

# keyed by integer, will be processed in ascending order
#  'how' to handle output may be append, prepend, replace, none

my %condition = ( '1' => { 'test'   => '$i % 3',
                           'expect' => '== 0',
                           'output' => 'Fizz',
                           'how'    => 'append'
                         },
                  '2' => { 'test'   => '$i % 5',
                           'expect' => '== 0',
                           'output' => 'Buzz',
                           'how'    => 'append'
                         }
                 );

for my $item ( $bound{'start'} .. $bound{'end'} ) {

    my $display = &run_tests($item) || $item;

    print $display . "\n";
}

sub run_tests {

    my ($item) = @_;

    my $output = '';

    return $output  if (( ! defined $item ) || ( ! $item ));

    foreach my $case ( sort keys %condition ) {

        my $params = $condition{$case};

        my $i = $item;  # this dumb looking thing serves as a hook for future debugging, which makes it not dumb

        my $cmd = "if ( $$params{'test'} $$params{'expect'} ) {
                        if ( \"$$params{'how'}\" eq 'append'  ) { \$output .= \"$$params{'output'}\";        }
                     elsif ( \"$$params{'how'}\" eq 'prepend' ) { \$output  = \"$$params{'output'}$output\"; }
                     elsif ( \"$$params{'how'}\" eq 'replace' ) { \$output  = \"$$params{'output'}\";        }
                     else  { }
                   }";

        eval($cmd);
    }

    return $output;
}
