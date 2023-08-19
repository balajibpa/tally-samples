<?php

function IsUTF16Request ()
{
	$headers = getallheaders();
	
	if (isset ($headers["UNICODE"]) && $headers["UNICODE"] == "YES")
		return TRUE;
	
	return FALSE;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

	if (IsUTF16Request ())
		$rqst_str = iconv("UCS-2LE", "UTF-8", $HTTP_RAW_POST_DATA);
	else
		$rqst_str = $HTTP_RAW_POST_DATA;
	
	$json_object = json_decode( $rqst_str );
	
	$contentfile = "./".$json_object->Branch.".json";
	if (file_exists ($contentfile))
		$respcont = file_get_contents ($contentfile);
	else
		throw new Exception ("Unable to find customer data file ".$contentfile);
	
	if (IsUTF16Request ())
		$respcont = iconv("UTF-8", "UCS-2LE", $respcont);
	
	$len = strlen( $respcont );
	
	if (IsUTF16Request ())
		$len = $len * 2;
	
	header ("CONTENT-LENGTH:".$len);
	print $respcont;
}
?>