function WaitProcess
{
    Param(
        [parameter(mandatory=$true)]
        [string]$Process2Monitor
    )

    Do { 
        $ProcessesFound = Get-Process | Where-Object{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name
        If ($ProcessesFound) {
            "Still running: $($ProcessesFound -join ', ')" | Write-Host
            Start-Sleep -Seconds 2 
        } else {
            Remove-Item "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose 
        } 
    } Until (!$ProcessesFound)
}


#---------------
#disable IE ESC
#---------------
function Disable-IEESC
{
$AdminKey = “HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}”
$UserKey = “HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}”
Set-ItemProperty -Path $AdminKey -Name “IsInstalled” -Value 0
Set-ItemProperty -Path $UserKey -Name “IsInstalled” -Value 0
Stop-Process -Name Explorer
}
Disable-IEESC

#--------------
#install chrome
#--------------
$LocalTempDir = $env:TEMP
$ChromeInstaller = "ChromeInstaller.exe"
(new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller")
& "$LocalTempDir\$ChromeInstaller" /silent /install

WaitProcess "ChromeInstaller"

#-------------------
#install Git
#-------------------
$LocalTempDir = $env:TEMP
$GitInstaller = "GitInstaller.exe"
(new-object    System.Net.WebClient).DownloadFile('https://github.com/git-for-windows/git/releases/download/v2.20.1.windows.1/Git-2.20.1-64-bit.exe', "$LocalTempDir\$GitInstaller")
& "$LocalTempDir\$GitInstaller" /silent
WaitProcess "GitInstaller"

#-------------------
#install TortoiseGit
#-------------------
$LocalTempDir = $env:TEMP
$TortoiseGitInstaller = "TortoiseGit.msi"
(new-object    System.Net.WebClient).DownloadFile('https://download.tortoisegit.org/tgit/2.7.0.0/TortoiseGit-2.7.0.0-64bit.msi', "$LocalTempDir\$TortoiseGitInstaller")
& "$LocalTempDir\$TortoiseGitInstaller" /passive
