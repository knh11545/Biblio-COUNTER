use ExtUtils::MakeMaker;

my $preop =
    'perldoc -uT $(VERSION_FROM) | tee $(DISTVNAME)/README.pod > README.pod;' .
    'pod2text README.pod | tee $(DISTVNAME)/README > README';

WriteMakefile(
	'NAME' => 'Biblio::COUNTER',
	'VERSION_FROM' => 'lib/Biblio/COUNTER.pm',
    'PREREQ_PM' => {
        'Text::CSV' => 0,
		'Log::Log4perl' => 0,
    },
    'EXE_FILES' => [ 'bin/counterproc' ],
	dist                => {
        COMPRESS => 'gzip -9f',
        SUFFIX => 'gz',
        PREOP => $preop,
    },
    clean               => { FILES => 'Biblio-COUNTER-*' },
);

