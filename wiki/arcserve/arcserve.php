<?php
# Alert the user that this is not a valid entry point to MediaWiki if they try to access the special pages file directly.
if (!defined('MEDIAWIKI')) {
        echo <<<EOT
To install this extension, put the following line in LocalSettings.php:
require_once( "\$IP/extensions/Arcserve/Arcserve.php" );
EOT;
        exit( 1 );
}
 
$wgExtensionCredits['specialpage'][] = array(
	'name' => 'ArcServe',
	'author' => 'Avi Greenbury',
	'url' => 'http://www.mediawiki.org/wiki/Extension:MyExtension',
	'description' => 'Default description message',
	'descriptionmsg' => 'myextension-desc',
	'version' => '0.0.0',
);
 
$dir = dirname(__FILE__) . '/';
 
$wgAutoloadClasses['MyExtension'] = $dir . 'MyExtension_body.php'; # Tell MediaWiki to load the extension body.
$wgExtensionMessagesFiles['MyExtension'] = $dir . 'MyExtension.i18n.php';
$wgExtensionAliasesFiles['MyExtension'] = $dir . 'MyExtension.alias.php';
$wgSpecialPages['MyExtension'] = 'MyExtension'; # Let MediaWiki know about your new special page.

