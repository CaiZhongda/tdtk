<?php

//SETTINGS
$CORRECT_KEY = "MyUniqueKey_EDIT_THIS!!";



$key = $_REQUEST['privateKey'];
$action = $_REQUEST['action'];

if($key!=$CORRECT_KEY){
    echo"0INVALID KEY";
    exit();
}

if($action=='postGameVersion'){

    $gameversion = $_REQUEST['gameversion'];
    
    $fh = fopen("buildversion.txt", 'w') or die("can't open file buildversion.txt. Please check it's CHMOD");
    $stringData = "$gameversion";
    fwrite($fh, $stringData);
    fclose($fh);
    
    echo "1";

}else{
	echo"0Invalid action";
}

						
?>