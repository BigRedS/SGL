<?php
$aliases = array();
 
/** English */
$aliases['en'] = array(
    'MyExtension' => array( 'MyExtension' ),
);
 
/** German (Deutsch) */
$aliases['de'] = array(
	'MyExtension' => array( 'MeineErweiterung', 'Meine Erweiterung' ),
);
/*
It allows the page title to be translated to another language. The page title can be customized into another language, the URL of the page would still be something like .../Special:MyExtension, even when the user language is not English. In this example, the special page MyExtension registers an alias so the page becomes accessible via .../Special:My_Extension eg. .../Spezial:Meine_Erweiterung in German, and so on.


A version of this example has been tested, and is checked in to MediaWiki SVN in examples/FourFileTemplate.
*/ 
