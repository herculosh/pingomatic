param(
	[string] $Computername = $(Read-Host "Computername")
)

$spath = split-path $SCRIPT:MyInvocation.MyCommand.Path -parent

. $spath\NetHelper.ps1; 

$ping = Set-Pinged $Computername;
$newping = Set-Pinged $Computername; 
while(1)
	{
		$newping = set-pinged $Computername; 

		if($ping.Result -ne $newping.Result)
		{
			write-host ("{0} " -f (Get-Date).ToString("dd.MM.yyyy hh:mm:ss")) -nonewline
			if($newping.Result -eq 0)
			{
				write-host ('Status on {1} Changed to {0}' -f $newping.Status, $Computername) -f green
			}
			else
			{
				write-host ('Status on {1} Changed to {0}' -f $newping.Status, $Computername) -f red
			}
			$ping = $newping
		}
		start-sleep 2
	}