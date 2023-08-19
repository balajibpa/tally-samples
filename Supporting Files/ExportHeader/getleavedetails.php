<?php

define ("RESP_FILE_NAME"		, "empleavedetails");
define ("TAG_LEAVE_INFO"		, "LeaveInfo");
define ("TAG_TYPE"				, "Type");
define ("TAG_ENTITLED"			, "Entitled");
define ("TAG_AVAILED"			, "Availed");
define ("TAG_ROOT"				, "Envelope");
define ("TAG_LEAVE_DETAILS"		, "LeaveDetails");
define ("TAG_EMPLOYEE"			, "Employee");
define ("TAG_EMPID"				, "EmpId");
define ("TAG_GENDER"			, "Gender");
define ("TAG_MATERNITY_LEAVE"	, "Maternity Leave");
define ("TAG_PATERNITY_LEAVE"	, "Paternity Leave");
define ("TAG_MALE"				, "Male");
define ("TAG_FEMALE"			, "Female");
define ("TAG_ALL_LEAVES"		, "All Leaves");

function GetTagStr ($pTagName, $pTagValue, $pIsXML, $pIsLast = FALSE)
{
	if ($pIsXML)
		return "<".$pTagName.">".$pTagValue."</".$pTagName.">";
	
	return '"'.$pTagName.'": "'.$pTagValue.'"'.($pIsLast ? "" : ",");
}

function GetLeaveInfoStr ($pObj, $pIsXML)
{
	$resp = "";
	
	if ($pIsXML)
		$resp .= '<'.TAG_LEAVE_INFO.'>';
	else
		$resp .= "{";
	
	$resp .= GetTagStr (TAG_TYPE, $pObj->Type, $pIsXML);
	$resp .= GetTagStr (TAG_ENTITLED, $pObj->Entitled, $pIsXML);
	$resp .= GetTagStr (TAG_AVAILED, $pObj->Availed, $pIsXML, TRUE);
	
	if ($pIsXML)
		$resp .= '</'.TAG_LEAVE_INFO.'>';
	else
		$resp .= "}";
	
	return $resp;
}

function GetRespStr ($pObj, $pLeaveType, $pIsXML)
{
	if ($pIsXML)
		$respstr = "<".TAG_ROOT."><".TAG_LEAVE_DETAILS.">";
	else
		$respstr = '{"'.TAG_LEAVE_DETAILS.'":{';
	
	$respstr .= GetTagStr (TAG_EMPLOYEE, $pObj->Employee, $pIsXML);
	$respstr .= GetTagStr (TAG_EMPID, $pObj->EmpId, $pIsXML);
	$respstr .= GetTagStr (TAG_GENDER, $pObj->Gender, $pIsXML);

	$count = count ($pObj->LeaveInfo);
	
	$isfirst = TRUE;
	for ($i = 0; $i < $count; $i++) {
		
		if ($i == 0 && !$pIsXML) {
			$respstr .= '"'.TAG_LEAVE_INFO.'": [';
		}		
			
		if (strcmp ($pObj->LeaveInfo[$i]->Type, $pLeaveType) == 0 || $pLeaveType == TAG_ALL_LEAVES) {
			if (strcmp ($pObj->LeaveInfo[$i]->Type, TAG_MATERNITY_LEAVE) == 0 && $pObj->Gender == TAG_MALE)		continue;
			if (strcmp ($pObj->LeaveInfo[$i]->Type, TAG_PATERNITY_LEAVE) == 0 && $pObj->Gender == TAG_FEMALE)	continue;
			
			if (!$isfirst && !$pIsXML)
				$respstr .= ",";
			
			$respstr .= GetLeaveInfoStr ($pObj->LeaveInfo[$i], $pIsXML);
			
			$isfirst = FALSE;
		}
	}
	
	if (!$pIsXML)
		$respstr .= ']';
	
	if ($pIsXML)
		$respstr .= "</".TAG_LEAVE_DETAILS."></".TAG_ROOT.">";
	else
		$respstr .= "}}";
	
	return $respstr;
}

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

function IsXMLRequest ()
{
	$acceptstr = strtoupper ($_SERVER['HTTP_ACCEPT']);
	
	if (strpos ($acceptstr, 'XML') !== false)	return TRUE;
	
	return FALSE;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

	if (IsUTF16Request ())
		$rqst_str = iconv("UCS-2LE", "UTF-8", $HTTP_RAW_POST_DATA);
	else
		$rqst_str = $HTTP_RAW_POST_DATA;
	
	if (IsXMLRequest()) {
		$rqst_data = simplexml_load_string ($rqst_str);
		$resp_data = simplexml_load_file (RESP_FILE_NAME.".xml");
	} else {
		$rqst_data = json_decode ($rqst_str);
		$resp_data = json_decode (file_get_contents (RESP_FILE_NAME.".json"));
	}
	
	$empcount = count ($resp_data->LeaveDetails);
	
	for ($i = 0; $i < $empcount; $i++) {
		if ($resp_data->LeaveDetails[$i]->EmpId == $_SERVER['HTTP_EMPID'])
			break;
	}
	
	$respcont = GetRespStr ($resp_data->LeaveDetails[$i], $rqst_data->LeaveType, IsXMLRequest());
	
	if (IsUTF16Request ())
		$respcont = iconv("UTF-8", "UCS-2LE", $respcont);
	
	$len = strlen($respcont);
	
	if (IsUTF16Request ())
		$len = $len * 2;
	
	header ("CONTENT-LENGTH:".$len);
	print $respcont;
}

?>