<php
$messages = array();
 
 $messages['en'] = array( 
 	'myextension' => 'My Extension',
);

/*

The message file can contain a great deal more information. The following example adds a description of the extension. It also adds a text for browsers specifying a preference for German.

//php
$messages = array();
 
/* *** English *** */
$messages['en'] = array( 
	'myextension' => 'My Extension',
	'myextension-desc' => "Extension's description",
);
 
/* *** German (Deutsch) *** */
$messages['de'] = array(
	'myextension' => 'Meine Erweiterung',
	'myextension-desc' => 'Beschreibung der Erweiterung',
);


Note that IDs should not start with an uppercase letter, and that a space in the ID should be written in the code as an underscore. For the page header and linking, the usual rules for page names apply. If $wgCapitalLinks is true, a lowercase letter is converted to uppercase, and an underscore is displayed as a space. For example: instead of the above, we could have used 'my_extension' => 'My extension', assuming we consistently identified the extension as my_extension elsewhere.
*/
