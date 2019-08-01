<?php
$Down=$_GET['Down'];
?>
 
<html>
	<head>
		<meta http-equiv="refresh" content="0;url=<?php echo $Down; ?>">
	</head>
	<body>
		<?php
			$file = "download_stsegments_count.txt";
			$fp = fopen($file, "r");
			$count = fread($fp, 1024);
			fclose($fp);
			$count = $count + 1;

			//Un-comment to display the downloads.
			//echo "Downloads:" . $count . "";
			$fp = fopen($file, "w");
			fwrite($fp, $count);
			fclose($fp);
		?>
	</body>
</html>
