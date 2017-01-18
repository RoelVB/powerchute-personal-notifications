<#
    Script to create tasks in Task Scheduler
#>

$folderName = "PowerChute"; # Task scheduler folder we're going to use
. .\EventIDs.ps1 # Import Event IDs


# Check for elevated permissions
if(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") -eq $false)
{
    Write-Error "You need to run this script as administrator";
    exit;
}

# We'll need this later when creating tasks
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition;

# Create a scheduler object
$scheduleObject = New-Object -ComObject schedule.service;
$scheduleObject.connect();

# Select our task scheduler folder
try {
    $scheduleFolder = $scheduleObject.GetFolder($folderName);
} catch {
    # Our folder probably doesn't exist, create it
    $rootFolder = $scheduleObject.GetFolder("\");
    $scheduleFolder = $rootFolder.CreateFolder($folderName);
}

function Create-ScheduledTask()
{
    param(
        [Parameter(Mandatory = $true)]
        [int]$EventID,
        # Extra arguments to pass to the event handler
        [string]$Arguments = $null
    )

    $task = $scheduleObject.NewTask(0);
    $trigger = $task.Triggers.Create(0); # 0 is an event trigger
    $trigger.Subscription = "<QueryList><Query Id='1'><Select Path='Application'>*[System[Provider[@Name='APC UPS Service'] and EventID=$EventID]]</Select></Query></QueryList>";
    $action = $task.Actions.Create(0);
    $action.WorkingDirectory = $scriptPath;
    $action.Path = "powershell";
    $action.Arguments = ".\EventHandler.ps1 -EventID $EventID $Arguments";
    
    $scheduleFolder.RegisterTaskDefinition("EventID $EventID", $task, 6, "System", $null, 5) > $null; # 6 means "create or update"
}

$events.GetEnumerator() | % {
    Write-Host "Creating task ""$($_.Value["Name"])"" (EventID: $($_.Key))";

    Create-ScheduledTask -EventID $_.Key;
}
