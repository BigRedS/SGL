<?php
class MyExtension extends SpecialPage {
	function __construct() {
		parent::__construct( 'MyExtension' );
		wfLoadExtensionMessages('MyExtension');
	}
 
	function execute( $par ) {
		global $wgRequest, $wgOut;
 
		$this->setHeaders();
 
		# Get request data from, e.g.
		$param = $wgRequest->getText('param');
 
		# Do stuff
		# ...

		# Output
		# $wgOut->addHTML( $output );
	}
}

/*execute() is the main function that is called when a special page is accessed. The function overloads the function SpecialPage::execute(). It passes a single parameter $par, the subpage component of the current title. For example, if someone follows a link to Special:MyExtension/blah, $par will contain "blah".

Wikitext and HTML output should normally be run via $wgOut -- do not use 'print' or 'echo' directly when working within the wiki's user interface.

However if you're using your special page as an entry point to custom XML or binary output, see Taking over output in your special page.

wfLoadExtensionsMessages('MyExtension') loads the messages defined in the message file that was given in MyExtension.php and that will be explained in the next section.
[edit] 
*/

