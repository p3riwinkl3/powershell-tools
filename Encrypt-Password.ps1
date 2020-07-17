param(
    [Parameter(Mandatory)][string]$username,
    [Parameter(Mandatory)][ValidateSet("encrypt","decrypt")][string] $action

)

function decryptPass{
    $Password = Get-Content -Path "$ConfigDir\$username.txt" | ConvertTo-SecureString
    $Credential = New-Object -typename System.Management.Automation.PSCredential -argumentlist $UserName,$Password
    Write-Host "$Credential has been created."
    $userinput = Read-Host "Do you want to print the password? (Type Y/N)"
    if ($userinput -eq "Y"){
        $pass_dec=$Credential.GetNetworkCredential().Password
        Write-Host "Decrypted Password is ${pass_dec}"
    } else{
        Write-Host "Exiting script..."
    }

}

function encryptPass{
Read-Host "Enter a password" -AsSecureString | ConvertFrom-SecureString | Out-File "$ConfigDir\$UserName.txt"
Write-host "$EncryptedFile has been created"
}

$ConfigDir = "$(Get-Location)\config"

If(!(test-path $ConfigDir))
{
      New-Item -ItemType Directory -Force -Path $ConfigDir
}

$EncryptedFile = "$ConfigDir\$username.txt" 

if ($action -eq "encrypt"){
    encryptPass

} elseif ($action -eq "decrypt") {
    if (!(Test-Path $EncryptedFile -PathType leaf)) {
    Write-Host "Encrypted password file ${EncryptedFile} doesn't exist!!"
    $UserInput = Read-Host "Want to encrypt password of ${username}? (Type Y/N)"
        if ($UserInput -eq "Y"){
            encryptPass
        } 
        else {Write-Host "No action done. Have a nice day"}
        
        }
    else{
        decryptPass

    }
    
}