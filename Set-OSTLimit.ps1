function Set-OSTLimit
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
         [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
         [string] $ComputerName,
         [string] $UserName,
         $SizeGB
         
    )

# 'OST/PST file MaxLargeFileSize Enter GB'
$MaxLargeFileSize = 1024 * $SizeGB
Write-Host "MaxLargeFileSize $MaxLargeFileSize MB"
$WarnLargeFileSize = $MaxLargeFileSize * .95
Write-Host "WarnLargeFileSize $WarnLargeFileSize MB"
$Value01 = $MaxLargeFileSize
$Value02 = $WarnLargeFileSize

#If (Test-Path $RegPath) {
#New-ItemProperty -Path $RegPath -Name $Name01 -Value $Value01 -PropertyType DWORD -Force 
#New-ItemProperty -Path $RegPath -Name $Name02 -Value $Value02 -PropertyType DWORD -Force 
#}

$SID = (Get-ADUser -Identity $UserName).SID.Value 

Invoke-Command -ComputerName $ComputerName -ScriptBlock {
$Name01 = "MaxLargeFileSize"
$Name02 = "WarnLargeFileSize"
$RegPath = "Microsoft.PowerShell.Core\Registry::HKEY_USERS\$Using:SID\Software\Microsoft\Office\*\Outlook\PST"
If (Test-Path $RegPath) {
New-ItemProperty -Path $RegPath -Name $Name01 -Value $Using:Value01 -PropertyType DWORD -Force 
New-ItemProperty -Path $RegPath -Name $Name02 -Value $Using:Value02 -PropertyType DWORD -Force 
}

}

}
