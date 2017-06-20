# not reworked on or tested
Function Discord-Ping {
     [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Text,
        
        [Parameter(Mandatory=$true)]
        $Channel,
        
        $ID = (get-date).ticks,
        $Timeout = 30
    )
$Ping=GetDate
        While  (!$Ping.IsInvoked) { { 
        $TimeTaken = ((get-date) - $DiscordPing).ms
        If ($TimeTaken -gt $Timeout) {
                    Send-DiscordMsg "API Ping: $DiscordPing" -Path $LogPath
            Return
        }
    }
  }
}