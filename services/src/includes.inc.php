<?php

/** file locations and other constants */
define("LIB", $_SERVER['DOCUMENT_ROOT'] . "/../lib/");
define("DB_NAME", "cp");
define("DB_USER", "cp");
define("DB_PASS", "cp");

include LIB . "VoteManager.php";

/** database abstraction */
include LIB . "db_connectivity_v2.php";
include LIB . "data_objects/VoteTable.php";

?>