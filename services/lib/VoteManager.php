<?php
/** 
 * Manages all aspects of voting.
 */
class VoteManager{

	/**
	 * Constructor.  DB abstraction layer, etc.
	 */
	function VoteManager(){
		$this->VoteTable = new VoteTable;
	}
	
	function vote($video_id, $ip_address){
		$vote_id = $this->VoteTable->insert($video_id, $ip_address, date("Y-m-d H:i:s"));
		if($vote_id){
			return true;
		} else {
			return false;
		}
	}
	
	function getResults(){
		$results = $this->VoteTable->getRawResults();
		$total_count = 0;
		if(is_array($results)){
			//ghetto...
			$num_videos = count($results);
			if($num_videos < 2){
				$video_we_have = $results[0]['video_id'];
				if($video_we_have == "blonde"){
					$results[1] = array("video_id"=>"jordan", "count"=>"0");
				} else {
					$results[1] = array("video_id"=>"blonde", "count"=>"0");				
				}
	
			}
		
		
			foreach($results as $result){
				$finalresults['raw_counts'][$result['video_id']] = $result['count'];
				$total_count = $total_count + $result['count'];
			}
			foreach($results as $result){
				$finalresults['percentages'][$result['video_id']] = round(($result['count'] / $total_count) * 100);
			}
			$finalresults['total_votes'] = $total_count;
			return $finalresults;
		} else {
			return false;
		}
	}


}

?>