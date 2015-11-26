function Get-CntlmHome {
	$env:CNTLM_HOME
}

<#
.Synopsis
	Install CNTLM
.DESCRIPTION
	Long description
.EXAMPLE
	Example of how to use this cmdlet
.EXAMPLE
	Another example of how to use this cmdlet
#>
function Install-Cntlm {


}

<#
.Synopsis
	Install CNTLM as a service
.DESCRIPTION
	Long description
.EXAMPLE
	Example of how to use this cmdlet
.EXAMPLE
	Another example of how to use this cmdlet
#>
function Install-CntlmService {


}

function Start-CntlmService{

}

function Start-Cntlm{
	[CmdletBinding()]
	param(
		[string]$ConfigFilePath
	)

	Write-Error 'Not Implemented!!!!'
}