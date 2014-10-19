<?php

include "../includes.inc.php";

$VoteManager = new VoteManager;

$results = $VoteManager->getResults(false);
if($results){
	//return overall results
	$results['status'] = "success";
	$return = $results;
	
} else {
	//error.  display error message
	$return = array(
				"status"=>"error",
				"message" => "Unable to retrieve results."
				);
}

echo json_encode($return);
exit;

?>