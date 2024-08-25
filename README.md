# Exile-VirtualGarage-Fix

What it does: This fixes a couple of problems with the serverside Virtual Garage scripts.
- Just realised the bug is still exists in the current server files and there is no public fix on the Exile Discord listed, nor is there a thread in the Unofficial forum.
- I optimised it slightly and also included the "Nickname problem" bug fixes from @Crito-VanaheimServers.
- Also fixes the client side trim string error message when you put a vehicle into the VG (was due to scheduled execution).

# Installation
1. Download ExileServer_object_vehicle_network_storeVehicleRequest & ExileServer_object_vehicle_network_retrieveVehicleRequest and copy them over the orginal files in your @ExileServer\addons\exile_server.pbo (Unpack -pbo -> Replace both files -> Repack exile_server.pbo).
- If you did any custom additions to these files you obviously need to merge them.

2. Download ExileClient_util_string_trim & ExileClient_gui_virtualGarageDialog_event_onConfirmButtonClicked and put them to your missionfile and add the CfgExileCustomCode for both.
	
		ExileClient_util_string_trim = "Overrides\ExileClient_util_string_trim.sqf";
		ExileClient_gui_virtualGarageDialog_event_onConfirmButtonClicked = "Overrides\ExileClient_gui_virtualGarageDialog_event_onConfirmButtonClicked.sqf";

3. To fix the issue with Nicknames for the Virtual Garage you also need to change this in your @ExileServer\sql_custom\exile.ini (Search for: confirmVehicleOwnership ).
# For extDB2
    [confirmVehicleOwnership]
    SQL1_1 = SELECT id,territory_id FROM vehicle WHERE nickname = ? 
    Number of Inputs = 2
    SQL1_INPUTS = 1, 2
    OUTPUT = 1

# For extDB3
    [confirmVehicleOwnership]
    SQL1_1 = SELECT id,territory_id FROM vehicle WHERE nickname = ? 
    SQL1_INPUTS = 1, 2
    OUTPUT = 1


