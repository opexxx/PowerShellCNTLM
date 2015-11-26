param([string]$InstallDirectory)

$CNTLMUserHomeDir = (Join-Path -Path ([Environment]::GetFolderPath('LocalApplicationData')) -ChildPath 'CNTLM')

if($env:CNTLM_HOME){
	$CNTLMHome = $env:CNTLM_HOME
}else{
	$CNTLMHome = ''
}

$DownloadCNTLM = $false

function Expand-ZIPFile($file, $destination) {
	$shell = new-object -com shell.application
	$zip = $shell.NameSpace($file)
	foreach($item in $zip.items()) {
		$shell.Namespace($destination).copyhere($item)
	}
}

function Get-CNTLM {
	param([string]$CntlmInstallDirectory)

	if (!(Test-Path $CntlmInstallDirectory)) {
		Write-Debug "Created CNTLM installation folder @ `"$CntlmInstallDirectory`"."
		$null = mkdir $CntlmInstallDirectory
	}

	$downloadsFolder = Join-Path  -Path $CntlmInstallDirectory -ChildPath '.downloads'

	if(!(Test-Path $downloadsFolder)){
		Write-Debug "Created CNTLM download folder @ `"$downloadsFolder`"."
		$null = mkdir $downloadsFolder
	}

	$zipFilePath = Join-Path -Path $downloadsFolder -ChildPath 'cntlm-0.92.3-win32.zip'

	$downloadLink = "http://downloads.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3-win32.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fcntlm%2Ffiles%2Fcntlm%2Fcntlm%25200.92.3%2F&ts=1448561446&use_mirror=skylineservers"
	$wc = New-Object System.Net.WebClient
	$wc.DownloadFile($downloadLink,$zipFilePath)

	Expand-ZIPFile $zipFilePath $downloadsFolder
	$files = Get-ChildItem  (Join-Path -Path $downloadsFolder -ChildPath "cntlm-0.92.3")
	
	foreach($file in $files){
		Move-Item -Path $file.FullName -Destination $CntlmInstallDirectory
	}	
}

function Get-PowerShellCNTLM {
	param([string]$InstallDirectory)

	if (!(Test-Path $InstallDirectory)) {
		$null = mkdir $InstallDirectory
	}	

	$downloadLink = "http://downloads.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3-win32.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fcntlm%2Ffiles%2Fcntlm%2Fcntlm%25200.92.3%2F&ts=1448561446&use_mirror=skylineservers"
	$wc = New-Object System.Net.WebClient
	$wc.DownloadFile($downloadLink,"$InstallDirectory\cntlm-0.92.3-win32.zip")
}

function Set-CNTLMHome {
	[Environment]::SetEnvironmentVariable("CNTLM_HOME", $CNTLMUserHomeDir, [System.EnvironmentVariableTarget]::User)
	$CNTLMUserHomeDir
}

function Find-CNTLMInstallation {
	$CNTLMSearchPaths = @( $CNTLMUserHomeDir, "C:\Program Files (x86)\Cntlm")
	$found = ''
	foreach($item in $CNTLMSearchPaths){
		$cntlmExe = Join-Path -Path $item -ChildPath 'cntlm.exe'

		if(Test-Path $cntlmExe){
			$found = $cntlmExe
			break
		}
	}

	$found
}

if ('' -eq $InstallDirectory)
{
    $personalModules = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules

    if (($env:PSModulePath -split ';') -notcontains $personalModules) {
        Write-Warning "$personalModules is not in `$env:PSModulePath"
    }

    if (!(Test-Path $personalModules)) {
        Write-Error "$personalModules does not exist"
    }

    $InstallDirectory = Join-Path -Path $personalModules -ChildPath PowerShellCNTLM
}

if ($CNTLMHome -eq ''){
	$CNTLMHome = Find-CNTLMInstallation

	if ($CNTLMHome -eq ''){
		$DownloadCNTLM = $true
		$CNTLMHome = Set-CNTLMHome
		Write-Host "A valid CNTLM installation could not be found. We will download CNTLM."	-ForegroundColor Yellow
	}
} else {
	Write-Host "Found an existing CNTLM installation at `"$CNTLHOME`"" -ForegroundColor Yellow
}


if($DownloadCNTLM){
	Get-CNTLM $CNTLMHome
}