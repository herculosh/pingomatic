# Ping all Servers 
# Examples: 
#	$serverstas = @(BulkpingUsage -servername @(200..203 | %{"SRV" + $_}))

function global:Set-Pinged($servername,$timeout = '4000', $SourceServer = ".")
{
	if($servername -is "System.String")
	{
		$serverhash = new-object psobject

			$serverhash = $serverhash | add-member -pass NoteProperty -Name Server $servername
			$serverhash = $serverhash | add-member -pass NoteProperty -name Result -value -1
			$serverhash = $serverhash | add-member -pass NoteProperty -name Status -value ""
			$serverhash = $serverhash | add-member -pass NoteProperty -name Time -value (Get-date)

		$pingresult=(Get-WmiObject -Query "select * from Win32_Pingstatus where Address='$servername' and timeout = $timeout" -ComputerName . | select Statuscode)
		$serverhash.Server = $servername
		$serverhash.Result = $pingresult.Statuscode
		$serverhash.Status = GetStatusString($pingresult.Statuscode)
		$serverhash
	}
	else
	{
		#all items $servername.count
		#percent $i/$events.count*100
		$count = 0
		
		foreach($server in $servername)
		{
			# If the Object is null it makes an error...
			if($server -is "System.Object")
			{
			write-progress "Ping Servers..." -status $server.Servername -percentcomplete ($count/$servername.count*100)
			$serverhash = new-object psobject

			$serverhash = $serverhash | add-member -pass NoteProperty -Name Server $server.Servername
			$serverhash = $serverhash | add-member -pass NoteProperty -name Result -value -1
			$serverhash = $serverhash | add-member -pass NoteProperty -name Status -value ""
			$serverhash = $serverhash | add-member -pass NoteProperty -name Time -value (Get-date)

			# Reset Pingresult because of the Automation Object is outputed every loop-rountrip
			$serverhash.Result = -1

			$servertoping = $server.Servername
			
			$pingresult=(Get-WmiObject -Class Win32_PingStatus -Filter "Address='$servertoping' and timeout = $timeout" -ComputerName $SourceServer | select Statuscode)
			$pingstats = (GetStatusString $pingresult.StatusCode $pingresult.PrimaryAddressResolutionStatus)

			#$serverhash.Servername = $server
			$serverhash.Status = $pingstats
			$serverhash.Result = $pingresult.Statuscode

			$server = $server | add-member -pass NoteProperty -Name Pinged $serverhash -Force
#			$serverhash

			#$server

			#$serverhash
			clear-variable -name serverhash
			clear-variable -name pingstats
			}
			$count++;
		}

	}

}


######################## 
#       Original Program - With typo in line 4 
#       Pasted into PowerShell window 
######################## 


Function Global:PingStatus ($Hostname) 
		{ 
				$PingObj = GWMI Win32_PingStatus -filter ("Address='" + $Hostname + "'") 
				if      ($PingObj.PrimaryAddressResolutionStatus -ne 0) 
						{$reason = "No DSN Entry" } 
				Else 
						{ 
						   Switch ($PingObj.StatusCode) 
								{ 
										0 { $Reason = "Success"} 
										11001 { $Reason = "Buffer Too Small"} 
										11002 { $Reason = "Destination Net Unreachable" } 
										11003 { $Reason = "Destination Host Unreachable" } 
										11004 { $Reason = "Destination Protocol Unreachable" } 
										11005 { $Reason = "Destination Port Unreachable "} 
										11006 { $Reason = "No Resources"} 
										11007 { $Reason = "Bad Option" } 
										11008 { $Reason = "Hardware Error"} 
										11009 { $Reason = "Packet Too Big" } 
										11010 { $Reason = "Request Timed Out "} 
										11011 { $Reason = "Bad Request" } 
										11012 { $Reason = "Bad Route" } 
										11013 { $Reason = "TimeToLive Expired Transit" } 
										11014 { $Reason = "TimeToLive Expired Reassembly"} 
										11015 { $Reason = "Parameter Problem" } 
										11016 { $Reason = "Source Quench" } 
										11017 { $Reason = "Option Too Big" } 
										11018 { $Reason = "Bad Destination"} 
										11032 { $Reason = "Negotiating IPSEC" } 
										11050 { $Reason = "General Failure" } 
										""      { $reason = "Not Resolved"} 
								default { $Reason = "Unknown"} 
								} 
						} 
				} 


Function Global:GetStatusString ($pingstatuscode, $primaryaddressresolutionstatus) 
{ 

	Switch ($pingstatuscode) 
	{ 
		0 { $Reason = "Success"} 
		11001 { $Reason = "Buffer Too Small"} 
		11002 { $Reason = "Destination Net Unreachable" } 
		11003 { $Reason = "Destination Host Unreachable" } 
		11004 { $Reason = "Destination Protocol Unreachable" } 
		11005 { $Reason = "Destination Port Unreachable "} 
		11006 { $Reason = "No Resources"} 
		11007 { $Reason = "Bad Option" } 
		11008 { $Reason = "Hardware Error"} 
		11009 { $Reason = "Packet Too Big" } 
		11010 { $Reason = "Request Timed Out "} 
		11011 { $Reason = "Bad Request" } 
		11012 { $Reason = "Bad Route" } 
		11013 { $Reason = "TimeToLive Expired Transit" } 
		11014 { $Reason = "TimeToLive Expired Reassembly"} 
		11015 { $Reason = "Parameter Problem" } 
		11016 { $Reason = "Source Quench" } 
		11017 { $Reason = "Option Too Big" } 
		11018 { $Reason = "Bad Destination"} 
		11032 { $Reason = "Negotiating IPSEC" } 
		11050 { $Reason = "General Failure" } 
		""      { $reason = "Not Resolved"} 
		default { $Reason = "Unknown"} 

	} 
	return $reason
} 

function MakePingTable($array)
{

	$out = new-object psobject

	foreach($item in $mycollection)
	{
		$out | add-member noteproperty Servername $item
	}


}