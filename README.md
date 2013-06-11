pingomatic
==========

Ping a computer or ping over a list of computers and display statuschanges in the
console. 

Status Change
================

Get-StatusChange can ping a single Computer and show his status. 

```powershell
.\Get-StatusChange.ps1 -Computername SRVFANTA
````

    @ pingomatic> .\Get-StatusChange.ps1 -Computername SRVFANTA
    11.25.2013 07:25:25 Status on SRVFANTA Changed to Not Resolved
    11.25.2013 07:25:35 Status on SRVFANTA Changed to Success
    @ pingomatic>

Ping Status
===========

Get-PingStatus can ping a bunch of computers from a textfile. 

```powershell
@ pingomatic> .\Get-PingStatus.ps1
````

    C:\Users\ivolooser\Documents\WindowsPowerShell\pingomatic
    Montoring output from all Jobs...
    11.39.2013 09:39:36 Status on SRV7UP Changed to Not Resolved
    11.39.2013 09:39:36 Status on SRVFANTA Changed to Not Resolved
    11.41.2013 09:41:08 Status on SRV7UP Changed to Success
    11.41.2013 09:41:09 Status on SRVFANTA Changed to Success

            Choose your Action [Q = Quit | L = List | C = Continue]: q



            Whould you like to stop all Jobs Y/N [Y]?: y
            Stopping jobs...

            Whould you like to remove all Jobs Y/N [Y]?: y
            Removing jobs...

    Thanks for using Pingomatic :-)
    @ pingomatic>

