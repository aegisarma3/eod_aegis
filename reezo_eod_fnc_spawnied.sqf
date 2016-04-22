// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};

private ["_soldier", "_rangeMin", "_rangeMax"];
_soldier = _this select 0;

if ((getPos _soldier) select 2 > 5) exitWith {};

// spacer..
// spacer..

_rangeMin = (_this select 1) select 0;
_rangeMax = (_this select 1) select 1;

//Check for other IEDs in the area
private ["_near"];
_near = nearestObjects [_soldier, ["Land_IED_v1_PMC","Land_IED_v2_PMC","Land_IED_v3_PMC","Land_IED_v4_PMC"], _rangeMax];

if (count _near > 0) exitWith {}; //Exit if other IEDs are found

//CHECK HOW MANY ROADS ARE IN THE AREA
private ["_nearRoads","_goodSpots","_nearRoads"];
_goodSpots = []; 
_nearRoads = (getPos _soldier) nearRoads _rangeMax;

if (count _nearRoads == 0) exitWith {}; //Exit if no roads are found

//FIND SUITABLE SPOTS AT LEAST 2/3 OF THE SOLDIER POSITION
private ["_i"];
for "_i" from 0 to (count _nearRoads - 1) do {
	if ((getPos (_nearRoads select _i)) distance getPos _soldier > _rangeMin && (getPos (_nearRoads select _i)) distance getPos _soldier < _rangeMax) then {
		_goodSpots set [count _goodSpots,getPos (_nearRoads select _i)];
	};
};

if (count _goodSpots == 0) exitWith {}; //Exit if no good spots are found

private ["_IEDpos","_IEDskins","_IED"];

//PICK A PLACE AND MAKE SURE NOONE IS NEAR IT
_IEDpos = _goodSpots select (floor (random (count _goodSpots)));
private ["_nearBodies"];
_nearBodies = _IEDpos nearEntities [["Man","Car","Motorcycle","Tank"],50];
if (count _nearBodies > 0) exitWith {}; //Exit if bodies are near (this way the IED does not auto-explode on spawn)

//IF IT IS ALL GOOD, SPAWN THE IED
_soldier setVariable ["reezo_eod_avail",false];
_IEDskins = ["Land_IED_v1_PMC","Land_IED_v2_PMC","Land_IED_v3_PMC","Land_IED_v4_PMC"];
_IED = createVehicle [_IEDskins select (floor (random (count _IEDskins))),_IEDpos, [], 5 + random 5, "NONE"];
_IED setDir (random 360);

if (true) exitWith{ nul0 = [_soldier, _IED, _rangeMax] execVM "x\eod\addons\eod\IED_postServerInit.sqf" };