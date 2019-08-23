<?php
function str_replace_first($search, $replace, $subject) {
    $pos = strpos($subject, $search);
    if ($pos !== false) {
        return substr_replace($subject, $replace, $pos, strlen($search));
    }
    return $subject;
}

$tssr = file_get_contents("php://input");
if (strpos($tssr,"<key>@BBTicket</key>") !== false) {
	$tssr = str_replace("UniqueBuildID","@UniqueBuildID",$tssr); // remove
	$tssr = str_replace_first("<integer>35120</integer>","<integer>35136</integer>",$tssr); // 0x8940
	$tssr = str_replace_first("<integer>6</integer>","<integer>2</integer>",$tssr); // iPad2,3
} 

$ch = curl_init();

curl_setopt($ch, CURLOPT_URL,            "https://gs.apple.com/TSS/controller?action=2" );
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 0 );
curl_setopt($ch, CURLOPT_POST,           1 );
curl_setopt($ch, CURLOPT_POSTFIELDS,     $tssr ); 
curl_setopt($ch, CURLOPT_HTTPHEADER,     array('Content-Type: text/xml; charset="utf-8"')); 
curl_setopt($ch, CURLOPT_FOLLOWLOCATION,1 );
curl_setopt($ch, CURLOPT_USERAGENT, "InetURL/1.0");
curl_exec ($ch);

?>
