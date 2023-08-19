<?php

function IsUTF16Request ()
{
	if (isset ($headers["HTTP_ACCEPT_CHARSET"]))
		$encoding = strtoupper ($headers["HTTP_ACCEPT_CHARSET"]);
	else
		$encoding = "";
	
	if (strpos ($encoding, "UTF-16") !== FALSE)
		return TRUE;
	
	return FALSE;
}

if ($_SERVER['REQUEST_METHOD'] != "GET")
	throw new Exception ("Expected GET Request but received ".$_SERVER['REQUEST_METHOD']);

$contentfile = "branchlist.json";

if (!file_exists ($contentfile))	throw new Exception ("File ".$contentfile." not found!!!");

$respcont = file_get_contents ($contentfile);

if (IsUTF16Request ())
	$respcont = iconv("UTF-8", "UCS-2LE", $respcont);
	
$len = strlen( $respcont );

if (IsUTF16Request ())
	$len = $len * 2;

header ("CONTENT-LENGTH:".$len);
print $respcont;
