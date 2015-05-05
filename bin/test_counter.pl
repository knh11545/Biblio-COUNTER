#!/usr/bin/perl -w
use strict;
use lib 'lib';
use feature qw(say);
use autodie;     # good to have when working with files 
    

use Biblio::COUNTER;

my $file = shift;
my $fh; open $fh, '<', $file;

my $report = Biblio::COUNTER->report(
    $fh,
    callback => { output => sub {} }                # suppress output
)->process;

say 'Name: ' . $report->name;
               # e.g., "Database Report 2 (R2)"

say 'Description: ' . $report->description;
               # e.g., "Turnaways by Month and Database"

say 'Customer: ' . $report->customer if defined $report->customer;

say 'Institutional Identifier: ' . $report->institutional_identifier if defined $report->institutional_identifier;

say 'Date run: ' . $report->date_run;
               # e.g., "2008-04-11"

say 'Criteria: ' . $report->criteria if defined $report->criteria;

say 'Publisher: ' . $report->publisher;

say 'Platform: ' . $report->platform;

my @periods = map { ( $report->parse_period($_) )[2] } @{$report->periods};
               # e.g., [ "2008-01", "2008-02", "2008-03" ]

foreach my $rec ($report->records) {
   say 'Title: ' . $rec->{title};
   say 'Publisher: ' . $rec->{publisher};
   say 'Platform: ' .  $rec->{platform};
   my $count = $rec->{count};
   foreach my $period (@periods) {
        my $period_count = $count->{$period};
        say "$period:";
        while ( my ($metric, $n) = each %$period_count) {
            say "$metric: $n";
            # e.g., ("turnaways", 3)
        }
    }
}

say 'ERRORS: ' . $report->errors;
say 'WARNINGS: ' . $report->warnings;
say 'is_valid: ' . $report->is_valid;
