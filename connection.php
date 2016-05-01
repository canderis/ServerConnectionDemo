<?php
	// Read request parameters
	//$value = $_REQUEST["data"];
	$returnValue = array("data"=>"Processed Data: " . json_encode($_POST) , 'success' => true);
	// Send back request in JSON format
	echo json_encode($returnValue);
?>