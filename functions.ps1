# Powershell functions

function gotoNand2Tetris { Set-Location "C:\Users\zachary.eller.WILSONLEGAL\Nextcloud\Documents\Learning\OSSU\Nand2Tetris\nand2tetris" }
function gotoProjects { Set-Location "$HOME\OneDrive - Harbor Global\Documents\Projects" }
function gotoScripts { Set-Location "$HOME\OneDrive - Harbor Global\Documents\Scripts" }

# To clear the Intapp Data Cache when troubleshooting or other reasons
function Clear-IntappCache {
	[CmdletBinding(SupportsShouldProcess=$true)]
	Param()

	Process
	{
		$dataCache = "$env:APPDATA\Intapp\Time\Data";
		if (Test-Path $dataCache) {
			Remove-Item -Recurse -Force $dataCache;
		}
	}
}
