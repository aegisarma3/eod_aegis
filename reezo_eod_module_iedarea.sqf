// IED Detection and Disposal Mod
// 2011 by Reezo

if (isServer) then
{
	_this setVariable ["initDone", false];

	sleep 0.5;

	// COMPILE RELATED FUNCTIONS
	reezo_eod_fnc_spawnied = compile preprocessFileLineNumbers "\eod\reezo_eod_fnc_spawnied.sqf";

	if (isNil {_this getVariable "reezo_eod_range"}) then
	{
		_this setVariable ["reezo_eod_range", [0,100]];
	};

	if (isNil {_this getVariable "reezo_eod_probability"}) then
	{
		_this setVariable ["reezo_eod_probability", 0.5];
	};

	if (isNil {_this getVariable "reezo_eod_interval"}) then
	{
		_this setVariable ["reezo_eod_interval", 600];
	};

	_this setVariable ["initDone", true];

};

if (_this getVariable "reezo_eod_interval" <= 1) exitWith { [_this, _this getVariable "reezo_eod_range"] call reezo_eod_fnc_spawnied };

while {alive _this} do
{
	private ["_rnd"];
	_rnd = random 1;

	if (_rnd < _this getVariable "reezo_eod_probability") then
	{
		[_this, _this getVariable "reezo_eod_range"] call reezo_eod_fnc_spawnied;
	};

	sleep (_this getVariable "reezo_eod_interval");
};

true
