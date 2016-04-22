// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};

private ["_soldier", "_bomber", "_rangeMax", "_victim"];
_soldier = _this select 0;
_bomber = _this select 1;
if (isNull _bomber) exitWith {};

_rangeMax = _this select 2;
_victim = objNull;

while {isNull _victim && alive _bomber} do
{
	_victim = [_soldier, _bomber, _rangeMax] call reezo_eod_fnc_suicidebomber_scan;
	sleep 5;
};

if (alive _bomber) then
{
	//Suicide Bomber found his victim and is going to run to it and make himself go boom
	_bomber enableAI "ANIM";
	_bomber enableAI "MOVE";
	_bomber enableAI "AUTOTARGET";
	_bomber enableAI "TARGET";
	_bomber doMove getPos _victim;
	_bomber addRating -1000;
	waitUntil {_bomber distance _victim < 10};

	_bomber playMoveNow "AmovPercMstpSsurWnonDnon";
	_bomber disableAI "ANIM";
	_bomber disableAI "MOVE";
	[_bomber, "reezo_eod_sound_akbar"] call CBA_fnc_globalSay3d;
	sleep 2;
	[_bomber] call reezo_eod_fnc_detonation;
};

_soldier setVariable ["reezo_eod_avail",true];
