<#
    Dictionary with known Event IDs
#>

$events = @{
    174=@{Severity="Warning"; Name="Blackout";};
    173=@{Severity="Warning"; Name="Under voltage";};
    172=@{Severity="Warning"; Name="Over voltage";};
    61453=@{Severity="Warning"; Name="Sensitivity fluctuation";};
    61452=@{Severity="Information"; Name="Self-test passed";};
    61451=@{Severity="Error"; Name="Self-test failed";};
    176=@{Severity="Information"; Name="Shutdown";};
    177=@{Severity="Information"; Name="Hibernation";};
    61455=@{Severity="Information"; Name="Online";};
    61460=@{Severity="Error"; Name="Battery disconnected";};
    61459=@{Severity="Information"; Name="Battery connected";};
    61461=@{Severity="Error"; Name="UPS overloaded";};
    61462=@{Severity="Information"; Name="UPS no longer overloaded";};
    61456=@{Severity="Error"; Name="Lost communication";};
    61483=@{Severity="Error"; Name="Lost communication while on battery";};
    61465=@{Severity="Information"; Name="Gained communication";};
    61464=@{Severity="Error"; Name="Charger failure";};
    203=@{Severity="Information"; Name="AC Utility Power (AVR Trim)";};
};