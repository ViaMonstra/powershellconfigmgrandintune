# Runs the Machine Policy Retrieval & Evaluation Cycle
$Trigger = "{00000000-0000-0000-0000-000000000021}"
Invoke-WmiMethod -Namespace root\ccm -Class sms_client -Name TriggerSchedule $Trigger