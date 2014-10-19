<?php

include "../includes.inc.php";

$VoteManager = new VoteManager;

if($VoteManager->vote($_REQUEST['video_id'], $_SERVER['REMOTE_ADDR'])){
	//voted.  return overall results
	$results = $VoteManager->getResults($_REQUEST['video_id']);
	if($results){
		$return = array(
					"status"=>"success",
					"user_voted_for" => $_REQUEST['video_id'],
					"results" => $results
					);
	} else {
		$return = array(
					"status"=>"error",
					"message" => "Unable to show results."
					);
	}
} else {
	//error.  display error message
	$return = array(
				"status"=>"error",
				"message" => "Unable to save vote."
				);
}

echo json_encode($return);
exit;

?>