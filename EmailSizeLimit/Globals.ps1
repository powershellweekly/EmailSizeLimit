#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------


#Sample function that provides the location of the script
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory


function Set-OSTLimit
{
	[CmdletBinding()]
	[Alias()]
	[OutputType([int])]
	Param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0)]
		$SizeGB
		
	)
	
	# 'OST/PST file MaxLargeFileSize Enter GB'
	$MaxLargeFileSize = 1024 * $SizeGB

	$WarnLargeFileSize = $MaxLargeFileSize * .95
	
	$Value01 = $MaxLargeFileSize
	$Value02 = $WarnLargeFileSize
	$Name01 = "MaxLargeFileSize"
	$Name02 = "WarnLargeFileSize"
	$RegPath = "HKCU:\Software\Microsoft\Office\*\Outlook\PST"
	If (Test-Path $RegPath)
	{
		Try
		{
			New-ItemProperty -Path $RegPath -Name $Name01 -Value $Value01 -PropertyType DWORD -Force -ErrorAction Stop
			$status.Text = "Set MaxLargeFileSize $MaxLargeFileSize MB Successful"
			Start-Sleep 2
			New-ItemProperty -Path $RegPath -Name $Name02 -Value $Value02 -PropertyType DWORD -Force -ErrorAction Stop
			$status.Text = "Set WarnLargeFileSize $WarnLargeFileSize MB Successful"
			Start-Sleep 2
			$status.Text = ""
			
		}
		Catch
		{
			$status.Text = $_.Exception.Message
		}
		
	}
	
}


