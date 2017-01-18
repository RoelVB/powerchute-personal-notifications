<#
    Event handler for Powerchute events
#>

param (
    [Parameter(Mandatory = $true)]
    [int]$EventID
)

. .\EventIDs.ps1 # Import Event IDs

# Read the INI file
$settings = @{}
switch -regex -file "settings.ini"
{
    "^\[(.+)\]$" {
        $section = $matches[1];
        $settings[$section] = @{};
    }
    "^(.+)=(.+?)(;.*)?$" {
        $name,$value = $matches[1..2];
        $settings[$section][$name] = $value.TrimEnd();
    }
}

# Should we log the received event?
if($settings['general']['Enablelogging'] -eq "true")
{
    Write-Host "Logging event $EventID";
    "$((Get-Date -Format G))`t$($EventID)" | Out-File -FilePath "events.log" -Append;
}

# Function for sending mail notifications
function Send-Email()
{
    param(
        [Parameter(Mandatory = $true)]
        [string]$Subject,
        [Parameter(Mandatory = $true)]
        [string]$Body
    )
    
    if($settings['mail']['username'] -ne "" -and $settings['mail']['password'] -ne "") # Is there a username and password?
    {
        $secpasswd = ConvertTo-SecureString $settings['mail']['password'] -AsPlainText -Force;
        $credentials = New-Object System.Management.Automation.PSCredential($settings['mail']['username'], $secpasswd);

        Send-MailMessage -Subject $Subject -Body $Body -SmtpServer $settings['mail']['server'] -From $settings['mail']['from'] -To $settings['mail']['to'] -Port $settings['mail']['port'] -UseSsl:($settings['mail']['usessl'] -eq "true") -Credential $credentials;
    }
    else
    {
        Send-MailMessage -Subject $Subject -Body $Body -SmtpServer $settings['mail']['server'] -From $settings['mail']['from'] -To $settings['mail']['to'] -Port $settings['mail']['port'] -UseSsl:($settings['mail']['usessl'] -eq "true");
    }

}

if(!$events.Contains($EventID)) # Unknown event ID?
{
    Write-Host -ForegroundColor Yellow "Unkown event ID $EventID, sending mail notification";
    $subject = "Powerchute: Unknown event";
    $body = "The Powerchute eventhandler recieved an unknown event ID $EventID`r`nDate/time: $((Get-Date -Format G))`r`nComputername: $env:COMPUTERNAME";
    Send-Email -Subject $subject -Body $body;

}
else # Known event ID
{
    $severity = $events[$EventID].Severity;
    $name = $events[$EventID].Name;

    # Do we need to send a notification?
    if($settings['notifications'][$severity] -eq "true" -or $settings['notifications'][[string]$EventID] -eq "true")
    {
        Write-Host "Sending a notification";
        $subject = "Powerchute: $name";
        $body = "Received a Powerchute $severity event $EventID : $name`r`nDate/time: $((Get-Date -Format G))`r`nComputername: $env:COMPUTERNAME";
        Send-Email -Subject $subject -Body $body;
    }

    # Do we need to run a command?
    if($settings['commands'][[string]$EventID])
    {
        Write-Host "Executing command ($($settings['commands'][[string]$EventID]))";
        Invoke-Expression $settings['commands'][[string]$EventID];
    }

}