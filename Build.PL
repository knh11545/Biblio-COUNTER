use utf8;
use Module::Build;

Module::Build->new(
    'module_name' => 'Biblio::COUNTER',
    'license'     => 'perl',
    'requires'    => { 
		'Text::CSV'     => 0, 
		'Log::Log4perl' => 0,
	},
    'dist_author' => [
		'Paul Hoffman <nkuitse@cpan.org>',
		'Todd Holbrook <holbrook@cpan.org>',
		'Helge Knüttel <helge.knuettel@ur.de>',
	],
	# create_makefile_pl => 'traditional', # Create a Makefile.PL
)->create_build_script;

