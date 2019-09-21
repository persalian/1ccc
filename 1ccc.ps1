param (
    [switch]$allusers=$true,
    [switch]$deletetemp=$false,
    [switch]$v=$false,
    [string]$user="-",
    [switch]$help=$false
)

if($help){
    $h = "The util size calculate and clear 1c caches of users
        1ccc.ps1 [-allusers] [-deletetemp] [-user username] [-help]
        -allusers - processing caches of all user profiles (default)
        -user username - processing caches username
        -deletetemp - clear caches
        -help - this help message
    ";
    Write-Output($h);
    Exit;
}

# enable verbose mode if --v setted
if($v){
    $VerbosePreference = "Continue";
}


if($user -ne "-"){ $allusers = $false; }

if ($allusers){
    $Computername = $env:COMPUTERNAME
    $adsi = [ADSI]"WinNT://$Computername"
    $Users = $adsi.Children  | where {$_.SchemaClassName  -eq 'user'}

    $1c_temp_sum = 0;

    ForEach ($u in $Users){
 
     $s="C:\Users\" + [string]$u.Name + "\";
     $ls = $s + "AppData\Local\1C\1cv8";
     $rs = $s + "AppData\Roaming\1C\1cv8";
 

     if(Test-Path $rs){
    
   
        $r_1c_temp_size = [int]((Get-ChildItem -Recurse $rs | Measure-Object -Sum  Length).Sum  );
        $l_1c_temp_size = [int]((Get-ChildItem -Recurse $ls | Measure-Object -Sum Length).Sum  );

        $1c_temp_sum = $1c_temp_sum + $l_1c_temp_size + $r_1c_temp_size;

        Write-Verbose "local $ls size $l_1c_temp_size B";
        Write-Verbose "roaming $rs size $r_1c_temp_size B";

        Write-Host -NoNewline "$($u.Name) local $([string]$l_1c_temp_size) bytes roaming $([string]$r_1c_temp_size) bytes ";
    
        if($deletetemp){
                $l_path = "$rs\*";
                $r_path = "$ls\*";
                if($v){Write-host " ";}
                Write-Verbose "delete $l_path";
                Write-Verbose "delete $r_path";

                Get-ChildItem $l_path |  Remove-Item -Force -Recurse;
                Get-ChildItem $r_path |  Remove-Item -Force -Recurse;
                Write-Host "... deleted"
        }else{
                Write-Host "."
        }
    
      } 
 
    
    }

}elseif($user -ne '-'){
    Write-Verbose "user $user";
    $s="C:\Users\" + $user + "\";
    $ls = $s + "AppData\Local\1C\1cv8";
    $rs = $s + "AppData\Roaming\1C\1cv8";
    if(Test-Path $rs){
    
        $r_1c_temp_size = [int]((Get-ChildItem -Recurse $rs | Measure-Object -Sum  Length).Sum  );
        $l_1c_temp_size = [int]((Get-ChildItem -Recurse $ls | Measure-Object -Sum Length).Sum  );

        $1c_temp_sum = $1c_temp_sum + $l_1c_temp_size + $r_1c_temp_size;

        Write-Verbose "local $ls size $l_1c_temp_size B";
        Write-Verbose "roaming $rs size $r_1c_temp_size B";

        Write-Host -NoNewline "$($user) local $([string]$l_1c_temp_size) bytes roaming $([string]$r_1c_temp_size) bytes ";
    
        if($deletetemp){
                $l_path = "$rs\*";
                $r_path = "$ls\*";
                if($v){Write-host " ";}
                Write-Verbose "delete $l_path";
                Write-Verbose "delete $r_path";

                Get-ChildItem $l_path |  Remove-Item -Force -Recurse;
                Get-ChildItem $r_path |  Remove-Item -Force -Recurse;
                Write-Host "... deleted"
        }else{
                Write-Host "."
        }
    
      } 

}

Write-Output "sum: $([int]$($1c_temp_sum / (1024 * 1024))) MB";