<?php

include "../includes.inc.php";

?>

<html>
<head>
	<title>Test: VOTE</title>
</head>

<body>

	<form action="/svcs/vote.php" method="post">
		Video:  <select name="video_id">
					<option value="jordan">Video 1 (jordan)</option>
					<option value="blonde">Video 2 (blonde)</option>
				</select>
		<br/>
		<input type="submit" name="submit" value="vote and get results" />
	</form>

</body>
</html>