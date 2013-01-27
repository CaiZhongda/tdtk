<?php
    //SETTINGS
    $filePath = 'http://downloads.M2H.nl/files/';   //The public link to where your files are
    $noPatchAvailableLink = "http://www.M2H.nl/";   //Where your users will be pointed to if no patch is available.
    
    //VARS
    $platform = $_REQUEST['platform'];
    $buildTarget = $_REQUEST['buildTarget'];//To be able to recognize a 64bit (windows) build we need the buildtarget(application.platform doesnt include this)
    $clientsversion = $_REQUEST['clientsversion'];

    //READ GAME VERSION
    $myFile = "buildversion.txt";
    $fh = fopen($myFile, 'r') or die("can't open file buildversion.txt. Please check it's CHMOD");
    $GAME_VERSION = fread($fh, filesize($myFile));
    fclose($fh);

    //PLATFORM SETTINGS
    $requiredPlatform = "";
    
    if($buildTarget=='StandaloneWindows64'){
        $requiredPlatform = "StandaloneWindows64"; 
    }else if($buildTarget=='StandaloneWindows' || $platform=='WindowsEditor' || $platform=='WindowsPlayer'){        
    	
        $requiredPlatform = "StandaloneWindows";        
    }else if($buildTarget=='StandaloneOSXIntel' || $platform=='OSXEditor' || $platform=='OSXPlayer' ){
        $requiredPlatform = "StandaloneOSXIntel";            
    }else{
    	echo 'Invalidplatform!';	
    	exit();
    }
      
    //Do we need to update?
    if($clientsversion < $GAME_VERSION){
        //SEARCH HIGHEST UPDATE NR: we prefer going from version 2 -> 8 directly if possible (instead of 2->3->4...)
        $usePatch = -1;
        $files = scandir("files"); 
        foreach($files as $key => $file){        
            if(strlen($file)<3) continue;        
            if(strpos($file, $requiredPlatform)==-1 || strpos($file, $requiredPlatform)===false ) continue; //The patch must match our platform
            
            if(strpos($file, "_".$clientsversion."_")>0){
                if(preg_match('/_[0-9]*\./',$file, $match)){                
                    foreach ($match as $key=>$value) { 
                       $nr = str_replace("_", "", $value);
                       $nr = str_replace(".", "", $nr);
                       if($nr>$usePatch || $usePatch==-1)
                       $usePatch = $nr;
                    }
                }
                
            }
        } 
        $downlink = "";
        if($usePatch>-1){
            $downlink = $filePath.$requiredPlatform."_$clientsversion"."_$usePatch.m2hpatch";    //EG: 'http://m2h.nl/BLA/StandaloneWindows_41_42.m2hpatch';  
        }else{
            //No patch found, redirect user to a page where help can be found
            $disabledLink = $noPatchAvailableLink."?patchUnavaiableFor=$clientsversion";
        }
    }  
      
    //Format:		VERSION#DOWNLOADLINK#DisabledLink
    //
    // Version: Latest version number    
    // Patch version: The version that the current downloadlink will patch to        
    // Download Link: The link to the .m2hpatch for this platform       
    // Disabled Link: You can use this when e.g. the patcher would need to be updated. Asks the user to visit this link with explanation. Leave this blank otherwise!
     
    //You can disable patching by setting the disabledlink. Users will be forwarded to this webpage. 
    //$disabledLink="http://www.M2H.nl/?gameOffline";
    
      
    //Final output
    if($disabledLink!="") $downlink = "";
    
    echo "1$GAME_VERSION#$usePatch#$downlink#$disabledLink";
    
    
   

?>