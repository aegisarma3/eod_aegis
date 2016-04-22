// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};

private ["_ied"];
_ied = _this select 0;

_IED removeAllEventHandlers "HandleDamage";
_IED removeAllEventHandlers "Hit";
_IED removeAllEventHandlers "MPHit";
_IED removeAllEventHandlers "Killed";
_IED removeAllEventHandlers "MPKilled";

private ["_powers","_power"];
_powers = ["small", "medium", "large"];
_power = _powers select (floor (random 3));

switch (_power) do {
	case "small" : {
		"Sh_105_HE" createVehicle getPos _IED;
	};
	case "medium" : {
		"Sh_120_HE" createVehicle getPos _IED;
	};
	case "large" : {
		"Sh_125_HE" createVehicle getPos _IED;
	};
};

//diag_log format["reezo_eod_fnc_detonation - %1 DETONATES WITH POWER %2", _IED, _power];

deleteVehicle _IED;