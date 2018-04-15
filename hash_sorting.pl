#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my %morning = ( "time" => 7,
                "meal" => "breakfast",
                "name" => "morning"
             );

my %noon = (    "time" => 12,
                "meal" => "lunch",
                "name" => "mid-day"
             );

my %night = (   "time" => 18,
                "meal" => "dinner",
                "name" => "night time"
             );

my @list_of_stuff = (\%morning, \%noon, \%night);

foreach my $field ('time', 'meal', 'name') {

   print "Sorting refs by: $field\n";
   my @sorted = &sort_by_field($field, @list_of_stuff);
   print Dumper @sorted;
   print "\n\n";
}

print "\ndone.\n\n";
exit;

sub sort_by_field {

    my ($sort_field, @hash_refs_to_sort) = @_;

    # first, determine if we are doing a numeric or standard alphabetical sort
    my $sort_type = 'numeric';
    foreach my $ref_hash ( @hash_refs_to_sort ) {  if ( $$ref_hash{$sort_field} =~ m/\D/ ) { $sort_type = 'alphabetic'; last; } }

    my %keyed_by_sort_field  = map {$$_{$sort_field}, $_}  @hash_refs_to_sort;  # create hash keyed on our desired sort field, and value is ref of hash it's in

    @hash_refs_to_sort = ();                                                    # clean up and repopulate with the sorted list of hash refs

    if ( $sort_type eq 'numeric' ) {

        foreach my $key ( sort numerically keys %keyed_by_sort_field ) { 

            push @hash_refs_to_sort , $keyed_by_sort_field{$key};
        }

    } else {

        # this does alpha sort, not numerical.. would give "12, 2, 36, 5, 7"
        foreach my $key ( sort keys %keyed_by_sort_field ) { 

            push @hash_refs_to_sort , $keyed_by_sort_field{$key};
        }
    }

    return @hash_refs_to_sort;

    sub numerically($$) {
        my ($one, $two) = @_;
        if (( ! defined $two ) || ( ! defined $one )) { return 0; }
        if (( $one eq ''     ) || ( $two eq ''     )) { return 0; }
        $one <=> $two;
    }
}
