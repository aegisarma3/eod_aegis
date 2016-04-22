// IED Detection and Disposal Mod
// 2011 by Reezo

if (isServer) then
{
	_this setVariable ["initDone", false];

	sleep 0.5;

	private ["_syncObjs"];
	_syncObjs = synchronizedObjects _this;

	private ["_syncObjsTmp"];
	_syncObjsTmp = +_syncObjs;

	{
		if (("Logic" countType [_x]) == 1) then {_syncObjs = _syncObjs - [_x]};
	} forEach _syncObjsTmp;

	if ((count _syncObjs) == 0) exitWith {diag_log "Log: [EOD_LoudSpeaker] Shutting down. No units were synchronized to the module."};

	// COMPILE RELATED FUNCTIONS
	// (no functions related to this script)

	private ["_range","_probability","_interval"];
	_range = if (isNil {_this getVariable "reezo_eod_range"}) then { [200,400] } else { _this getVariable "reezo_eod_range" };
	_probability = if (isNil {_this getVariable "reezo_eod_probability"}) then { 0.8 } else { _this getVariable "reezo_eod_probability" };
	_interval = if (isNil {_this getVariable "reezo_eod_interval"}) then { 30 } else { _this getVariable "reezo_eod_interval" };

	{
		[-1, {reezo_eod_action_loudspeaker = (_this select 0) addAction ['<t color="#FF9900">'+"Loudspeaker (Evacuate Civilians)"+'</t>', "\eod\reezo_eod_action_loudspeaker_evacuate.sqf", [_this select 0,_this select 1,_this select 2,_this select 3], 0, false, true, "",""]}, [_x, _range, _probability, _interval]] call CBA_fnc_globalExecute;
	} forEach _syncObjs;

	_this setVariable ["initDone", true];
};

true
