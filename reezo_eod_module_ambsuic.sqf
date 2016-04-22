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

	if ((count _syncObjs) == 0) exitWith {diag_log "Log: [EOD_AMBSUIC] Shutting down. No units were synchronized to the module."};

	// COMPILE RELATED FUNCTIONS
	reezo_eod_fnc_spawnsuic = compile preprocessFileLineNumbers "\eod\reezo_eod_fnc_spawnsuic.sqf";
	reezo_eod_module_ambsuic_loop = compile preprocessFileLineNumbers "\eod\reezo_eod_module_ambsuic_loop.sqf";
	reezo_eod_fnc_suicidebomber_scan = compile preprocessFileLineNumbers "\eod\reezo_eod_fnc_suicidebomber_scan.sqf";

	if (isNil {_this getVariable "reezo_eod_range"}) then
	{
		_this setVariable ["reezo_eod_range", [400,700]];
	};

	if (isNil {_this getVariable "reezo_eod_probability"}) then
	{
		_this setVariable ["reezo_eod_probability", 0.1];
	};

	if (isNil {_this getVariable "reezo_eod_interval"}) then
	{
		_this setVariable ["reezo_eod_interval", 180];
	};

	for "_i" from 0 to (count _syncObjs - 1) do
	{
		private ["_thisUnit"];
		_thisUnit = leader group (_syncObjs select _i);

		if (isNil {_thisUnit getVariable "reezo_eod_synced_ambied"}) then
		{
			[_this, _thisUnit] spawn reezo_eod_module_ambsuic_loop;
			_thisUnit setVariable ["reezo_eod_synced_ambsuic", true];
		};
	};

	_this setVariable ["initDone", true];
};

true
