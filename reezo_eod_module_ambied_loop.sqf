// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};
private ["_module", "_soldier", "_grp", "_rnd"];
_module = _this select 0;
_soldier = _this select 1;
_grp = group _soldier;

while {count units _grp > 0 } do
{
	//If soldier has no module availability set, set it
	if (isNil {_soldier getVariable "reezo_eod_avail"}) then
	{
		_soldier setVariable ["reezo_eod_avail",true];
		waitUntil {!isNil {_soldier getVariable "reezo_eod_avail"}};
	};
	
	_rnd = random 1;
	
	//If module is not busy for this soldier and the random number is lower than the probability, call spawn
	if (_soldier getVariable "reezo_eod_avail" && _rnd < _module getVariable "reezo_eod_probability") then
	{
		[_soldier, _module getVariable "reezo_eod_range"] call reezo_eod_fnc_spawnied;
	};
	
	//Sleep for the interval number in seconds
	sleep (_module getVariable "reezo_eod_interval");
	
	//If Team Leader dies, pick the new leader and keep going
	if !(alive _soldier) then {
		_soldier = leader _grp;
		waitUntil {alive _soldier};
	};	
};
