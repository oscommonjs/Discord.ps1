# Invokes an instance of a bot
# Some functions might not work
Function Invoke-DiscordBot {
    [cmdletbinding()]
    Param(
        [string]$Token = (Import-Clixml "$PSscriptPath\..\Token.xml"),  
        [string]$LogPath = "$Env:USERPROFILE\Logs\DiscordBot.log",
        [string]$PSDiscordConfigPath = "$PSscriptPath\..\PSDiscordConfig.xml"
    )
    
    Set-PSDiscordConfig -Path $PSDiscordConfigPath -token $Token
    $DiscordSession = Invoke-RestMethod -Uri https://discordapp.com/api/oauth2/token -Body @{token="$Token"}
    Write-Log "Logged in as $($DiscordSession.self.name)" -Path $LogPath