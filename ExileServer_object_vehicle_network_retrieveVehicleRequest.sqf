/**
 * ExileServer_object_vehicle_network_retrieveVehicleRequest
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 * 64Bit Conversion File Header (Extdb3) - Validatior
 */
params["_sessionID", "_parameters"];
private _nickname = _parameters select 0;
private _playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
private _flagObject = objNull;
try
{
	if (isNull _playerObject) then 
	{
		throw "Player is null";
	};
	if (_playerObject getVariable ["ExileMutex",false]) then
	{
		throw "Player is Mutex";
	};
	_playerObject setVariable ["ExileMutex", true];
	_flagObject = _playerObject call ExileClient_util_world_getTerritoryAtPosition;
	if (isNull _flagObject) then 
	{
		throw "Invalid Flag";
	};
	if (_flagObject getVariable [format["Exile%1Mutex", toLower(_nickname)], false]) then 
	{
		throw "Vehicle is being processed by another player.";
	};
	_flagObject setVariable [format["Exile%1Mutex", toLower(_nickname)], true];
	private _territoryID = _flagObject getVariable ["ExileDatabaseID", -1];
	private _vehicleInfo = format["confirmVehicleOwnership:%1:%2", _nickname, _territoryID] call ExileServer_system_database_query_selectSingle;
	if !((_vehicleInfo select 1) isEqualTo _territoryID) then 
	{
		throw "Vehicle does not belong to this territory!";
	};
	private _buildRights = _flagObject getVariable ["ExileTerritoryBuildRights", []];
	if !((getPlayerUID _playerObject) in _buildRights) then 
	{
		throw "You do not have rights to access this Virtual Garage";
	};
	private _VGindex = -1;
	private _storedVehicles = _flagObject getVariable ["ExileTerritoryStoredVehicles", []];
	{
		if (toLower(_x select 1) isEqualTo toLower(_nickname)) exitWith {_VGindex = _forEachIndex};
	} forEach _storedVehicles;
	if (_VGindex isEqualTo -1) then 
	{
		throw "Unable to find vehicle in stored vehicles";
	};
	_storedVehicles deleteAt _VGindex;
	_flagObject setVariable ["ExileTerritoryStoredVehicles", _storedVehicles, true];
	format["retrieveVehicle:%1", _vehicleInfo select 0] call ExileServer_system_database_query_fireAndForget;
	(_vehicleInfo select 0) call ExileServer_object_vehicle_database_load;
	[_sessionID, "retrieveVehicleResponse", [true]] call ExileServer_system_network_send_to;
}
catch
{
	[_sessionID, "retrieveVehicleResponse", [false]] call ExileServer_system_network_send_to;
	[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Retrieve Vehicle Failed!", _exception]]] call ExileServer_system_network_send_to;
	_exception call ExileServer_util_log;	
};
_flagObject setVariable [format["Exile%1Mutex", toLower(_nickname)], nil];
_playerObject setVariable ["ExileMutex", false];
true