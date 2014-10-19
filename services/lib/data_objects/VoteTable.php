<?php

class VoteTable{

	var $DB;
	var $result_array;

	function VoteTable(){
		$this->DB = new DB;
		$this->result_array[0] = "video_id";
		$this->result_array[1] = "count";
	}

	function getResults(){
	
	}

	function getRawResults(){
		$query = 
			"SELECT video_id, COUNT(*) AS count FROM vote GROUP BY video_id ORDER BY video_id";
		$this->DB->query($query);
	    return $this->DB->getResultArray($this->result_array);
	}
	
	function insert($video_id, $ip_address, $datestamp){
		$query = 
			"INSERT INTO vote (video_id, ip_address, datestamp) VALUES ('$video_id', '$ip_address', '$datestamp')";
		$this->DB->query($query);
	    return $this->DB->last_id();
	}

}

?>