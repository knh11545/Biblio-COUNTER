package Biblio::COUNTER::Report::Release2::DatabaseReport3;

use strict;
use warnings;

use Biblio::COUNTER::Report qw(REQUESTS SEARCHES SESSIONS MAY_BE_BLANK NOT_BLANK EXACT_MATCH);

@Biblio::COUNTER::Report::Release2::DatabaseReport3::ISA = qw(Biblio::COUNTER::Report);

sub canonical_report_name { 'Database Report 3 (R2)' }
sub canonical_report_description { 'Total Searches and Sessions by Month and Service' }
sub canonical_report_code { 'DB3' }
sub release_number { 2 }

sub process_header_rows {
    my ($self) = @_;
    
    # Report name and title
    $self->begin_row
         ->check_report_name
         ->check_report_description
         ->end_row;
    
    # Report criteria
    $self->begin_row
         ->check_report_criteria
         ->end_row;
    
    # Date run label
    $self->begin_row
         ->check_label('Date run:')
         ->end_row;
    
    # Date run
    $self->begin_row
         ->check_date_run
         ->end_row;
    
    # Data column labels
    $self->begin_row
         ->check_blank
         ->check_label('Platform',    qr/^(?i)plat/)
         ->check_blank
         ->check_period_labels
         ->check_label('YTD Total')
         ->end_row;
}

sub process_record {
    my ($self) = @_;
    
    # First row -- searches run
    $self->begin_row
         ->check_title(NOT_BLANK)
         ->check_platform(NOT_BLANK)
         ->check_label('Searches run')
         ->check_count_by_periods(SEARCHES)
         ->check_ytd_total
         ->end_row;
    
    # Fields that must be the same in the second row as in the first
    my $record = $self->{'record'};
    my ($title, $platform) = @$record{qw(title platform)};
    
    # Second row -- sessions
    $self->begin_row
         ->check_title(EXACT_MATCH, $title)
         ->check_platform(EXACT_MATCH, $platform)
         ->check_label('Sessions')
         ->check_count_by_periods(SESSIONS)
         ->check_ytd_total
         ->end_row;
    
    $self->blank_row;
}

1;
