# Powershell scripts to monitor and manage Powerchute Personal events

## Software requirements

- Operational Powerchute Personal

- Windows Vista/2008 or higher

## Installation

1. Put al the files from this repository in a folder on your system running Powerchute Personal
2. Review `settings.ini` and set your desired settings
3. Run `.\CreateScheduledTasks.ps1` in a Powershell window (as administrator) (this will create a set of tasks in your Task Scheduler)
4. You're all set

## Test your settings

You should always test your settings, because you don't want to get caught by surprise if there is a power outage. The best way is a real-life test, just unplug your UPS's power input.

There is another way to test, without having to unplug your UPS. If for example you want to test a blackout event:

1. Lookup the event in the table below
2. Open a Command-prompt
3. Execute the following command: `eventcreate /ID 174 /L Application /T Warning /SO "APC UPS Service" /D "Test Event"` 
4. The eventhandler will be fired (you can change the ID 174 in this command to test other events)

## Available Powerchute events

| Event                               | Event ID | Event Severity |
| ----------------------------------- | -------- | -------------- |
| Blackout (on battery power)         | 174      | Warning        |
| Under voltage                       | 173      | Warning        |
| Over voltage                        | 172      | Warning        |
| Sensitivity fluctuation             | 61453    | Warning        |
| Self-test passed                    | 61452    | Information    |
| Self-test failed                    | 61451    | Error          |
| Shutdown                            | 176      | Information    |
| Hibernation                         | 177      | Information    |
| Online (on AC utility power)        | 61455    | Information    |
| Battery disconnected                | 61460    | Error          |
| Battery connected                   | 61459    | Information    |
| UPS overloaded                      | 61461    | Error          |
| UPS no longer overloaded            | 61462    | Information    |
| Lost communication                  | 61456    | Error          |
| Lost communication while on battery | 61483    | Error          |
| Gained communication                | 61465    | Information    |
| Charger failure                     | 61464    | Error          |
| AC Utility Power (AVR Trim)         | 203      | Information    |