use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME' => 'Biblio::COUNTER',
	'VERSION_FROM' => 'lib/Biblio/COUNTER.pm',
    'PREREQ_PM' => {
        'Text::CSV' => 0,
		'Log::Log4perl' => 0,
    },
    'EXE_FILES' => [ 'bin/counterproc' ],
);

