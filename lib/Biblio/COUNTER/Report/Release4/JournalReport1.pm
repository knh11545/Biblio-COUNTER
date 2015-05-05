package Biblio::COUNTER::Report::Release4::JournalReport1;

use strict;
use warnings;

use Biblio::COUNTER::Report qw(REQUESTS MAY_BE_BLANK NOT_BLANK);

@Biblio::COUNTER::Report::Release4::JournalReport1::ISA = qw(Biblio::COUNTER::Report);

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($INFO);

sub canonical_report_name { 'Journal Report 1 (R4)' }
sub canonical_report_description { 'Number of Successful Full-text Article Requests by Month and Journal' };
sub canonical_report_code { 'JR1' }
sub release_number { 4 }

# Constants
use constant MAX_NUM_PERIODS => 15;   # Sensible maximum number of period columns in report.
                                      # The COUNTER R4 Code of Practice gives no limit.
				      # Report.pm only allows for 26 columns in _next.

# Line 3 might be blank bust must not be skipped.
# Therefore, we override the method from Report.pm.
sub begin_row {
    my ($self) = @_;
    $self->trigger_callback('begin_row');
    my $fh = $self->{'fh'};
	while (!eof $fh) {
		my $row = $self->_read_next_row;
		TRACE 'Biblio::COUNTER::Report::Release4::JournalReport1->begin_row (', $self->current_position,'): |', join('|', @$row), '|';
		my $row_str = join('', @$row);
		if ($row_str =~ /\S/) {
			last;
		} elsif ($self->current_position eq 'A3') {
			INFO 'Biblio::COUNTER::Report::Release4::JournalReport1->begin_row: Row 3 (Institutional Identifier) is blank.';
			last;
		} else {
			# Oops -- blank row where one wasn't expected
			INFO 'Biblio::COUNTER::Report::Release4::JournalReport1->begin_row: row ', $self->current_position,' is blank.';
			$self->trigger_callback('fixed', '<row>', '<blank>', '<skipped>');
			$self->{'warnings'}++;
		}
	}
    return $self;
}

				      
sub process_header_rows {
    my ($self) = @_;
    
    # Report name and title; row 1
    $self->begin_row
         ->check_report_name
         ->check_report_description
         ->end_row;
    
    # Customer; row 2
    $self->begin_row
         ->check_customer
         ->end_row;
    
    # Institutional Identifier; row 3
    $self->begin_row
         ->check_institutional_identifier
         ->end_row;
    
    # Period covered label; row 4
    $self->begin_row
         ->check_label('Period covered by Report:')
         ->end_row;
    
    # Period covered; row 5
    $self->begin_row
         ->check_period_covered
         ->end_row;
    
    # Date run label; row 6
    $self->begin_row
         ->check_label('Date run:')
         ->end_row;
    
    # Date run; row 7
    $self->begin_row
         ->check_date_run
         ->end_row;
    
    # Data column labels; row 8
    $self->begin_row
         ->check_label('Journal',                qr/^(?i)journal/)
         ->check_label('Publisher',              qr/^(?i)pub/)
         ->check_label('Platform',               qr/^(?i)plat/)
         ->check_label('Journal DOI',            qr/^(?i)journal doi/)
         ->check_label('Proprietary Identifier', qr/^(?i)proprietary identifier/)
         ->check_label('Print ISSN',             qr/^(?i)print issn/)
         ->check_label('Online ISSN',            qr/^(?i)online issn/)
         ->check_label('Reporting Period Total', qr/^(?i)reporting period total/)
         ->check_label('Reporting Period HTML',  qr/^(?i)reporting period html/)
         ->check_label('Reporting Period PDF',   qr/^(?i)reporting period pdf/)
         ->check_period_labels(MAX_NUM_PERIODS)
         ->end_row;
    
    # Data summary; row 9
    $self->begin_row
         ->check_label('Total for all journals')
         ->check_publisher(MAY_BE_BLANK)
         ->check_platform(MAY_BE_BLANK)
         ->check_blank
         ->check_blank
         ->check_blank
         ->check_blank
         ->check_reporting_period_total(REQUESTS)
         ->check_reporting_period_html(REQUESTS)
         ->check_reporting_period_pdf(REQUESTS)
         ->check_count_by_periods(REQUESTS)
         ->end_row;
    
}

sub process_record {
    my ($self) = @_;
    $self->begin_row
         ->check_title(NOT_BLANK)
         ->check_publisher(MAY_BE_BLANK)
         ->check_platform(NOT_BLANK)
	 ->check_journal_doi
	 ->check_proprietary_identifier(MAY_BE_BLANK)
         ->check_print_issn
         ->check_online_issn
         ->check_reporting_period_total(REQUESTS)
         ->check_reporting_period_html(REQUESTS)
         ->check_reporting_period_pdf(REQUESTS)
         ->check_count_by_periods(REQUESTS)
         ->end_row;
}


1;

=pod

=head1 NAME

Biblio::COUNTER::Report::Release4::JournalReport1 - a JR1 (R4) COUNTER report

=head1 SYNOPSIS

    $report = Biblio::COUNTER::Report::Release4::JournalReport1->new(
        'file' => $file,
    );
    $report->process;

=cut
