################## Some Globals 

write-verbose "getting VMware Path from Registry"
if (!(Test-Path "HKCR:\")) { $NewPSDrive = New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT }
if (!($VMWAREpath = Get-ItemProperty HKCR:\Applications\vmware.exe\shell\open\command -ErrorAction SilentlyContinue))
{
	Write-Debug "VMware Binaries not found from registry"; Break
}
$VMWAREpath = Split-Path $VMWAREpath.'(default)' -Parent
$VMWAREpath = $VMWAREpath -replace '"', ''
$Global:vmwarepath = $VMWAREpath
$Global:vmware = "$VMWAREpath\vmware.exe"
$Global:vmrun = "$VMWAREpath\vmrun.exe"
$vmwarefileinfo = Get-ChildItem $Global:vmware

### End VMWare Path
$Global:VMrunErrorCondition = @("Waiting for Command execution Available", "Error", "Unable to connect to host.", "Error: The operation is not supported for the specified parameters", "Unable to connect to host. Error: The operation is not supported for the specified parameters", "Error: vmrun was unable to start. Please make sure that vmrun is installed correctly and that you have enough resources available on your system.", "Error: The specified guest user must be logged in interactively to perform this operation")
$Global:vmxdir = split-path $PSScriptRoot
$Global:vmwareMajor = $vmwarefileinfo.VersionInfo.ProductMajorPart
$Global:vmwareMinor = $vmwarefileinfo.VersionInfo.ProductMinorPart
$Global:vmwareBuild = $vmwarefileinfo.VersionInfo.ProductBuildPart
$Global:vmwareversion = $vmwarefileinfo.VersionInfo.ProductVersion