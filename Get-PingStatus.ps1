cls

. $PWD\NetHelper.ps1

write-host $PWD



foreach($item in (gc $PWD\ServerList.txt))
{

	$rootPath = $PWD

	$scriptPathNetHelper = (gc (join-path -path $rootPath -child NetHelper.ps1)) | out-string	

	$scriptPath = (join-path -path $PWD -child Get-StatusChange.ps1)

	$script = [scriptblock]::Create(("{0};. {1} -computername '{2}'" -f $scriptPathNetHelper,$scriptPath,$item)) 

	$job = start-job -name ("Ping {0}" -f $item) -scriptblock $script
}

$run = $true

write-host "Montoring output from all Jobs..."
while((Get-job).Count -gt 0 -and $run)
{
	foreach($job in Get-job)
	{
		Receive-Job $job
	}

	if ($host.UI.RawUI.KeyAvailable)
	{ 
		$pressedkey = "C"
		$pressedkey = Read-Host "`n`tChoose your Action [Q = Quit | L = List | C = Continue]" 

		write-host "`n"
		
		if ($pressedkey.ToUpper() -ne "C")
		{
			if($pressedkey.ToUpper() -eq "Q")
			{
				$shouldstop = "Y"
				$shouldstop = Read-host "`n`tWhould you like to stop all Jobs Y/N [Y]?"
				if($shouldstop.ToUpper() -eq "Y" -or $shouldstop -eq "")
				{
					write-host "`tStopping jobs..."
					Get-job | stop-job
					$run = $false
				}

				$shouldremove = Read-host "`n`tWhould you like to remove all Jobs Y/N [Y]?"
				if($shouldremove.ToUpper() -eq "Y" -or $shouldremove -eq "")
				{
					write-host "`tRemoving jobs..."
					Get-job | remove-job -force
				}
			}
			
			if($pressedkey.ToUpper() -eq "L")
			{
				Get-job | ft
				write-host " "
			}
		}
	}

}

Write-host "`nThanks for using Pingomatic"
