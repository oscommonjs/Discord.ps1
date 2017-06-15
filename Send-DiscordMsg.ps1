Function Send-DiscordMsg {
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Text,
        
        [Parameter(Mandatory=$true)]
        $Channel,
        
        $ID = (get-date).ticks,
        $Timeout = 30
    )
    
    If (!($WS -is [System.Net.WebSockets.ClientWebSocket])){
        Write-Log  -Level Error 'A WebSocket to Discord is not open via $WS.' -Path $LogPath
        Return
    }

    $Prop = @{'id'      = $ID;
              'type'    = 'message';
              'text'    = $Text;
              'channel' = $Channel}
            
    $Msg = (New-Object –TypeName PSObject –Prop $Prop) | ConvertTo-Json
            
    $Array = @()
    $Msg.ToCharArray() | ForEach-Object { $Array = $Array + [byte]$_ }
           
    $Msg = New-Object System.ArraySegment[byte]  -ArgumentList @(,$Array)

    $Conn = $WS.SendAsync($Msg, [System.Net.WebSockets.WebSocketMessageType]::Text, [System.Boolean]::TrueString, $CT)
    $ConnStart = Get-Date

    While (!$Conn.IsCompleted) { 
        $TimeTaken = ((get-date) - $ConnStart).Seconds
        If ($TimeTaken -gt $Timeout) {
            Write-Log -Level Error "Message $ID took longer than $Timeout seconds and timed out." -Path $LogPath
            Return
        }
        Start-Sleep -Milliseconds 100 
    }
   
}