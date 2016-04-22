// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};

private ["_ied","_damage","_projectile"];
_ied = _this select 0;
_damage = _this select 2;
_projectile = _this select 4;

//hintSilent format["%1\n\n%2",_damage,_projectile];

if (_damage > 0.33) exitWith {
	_IED removeAllEventHandlers "HandleDamage";
	_IED removeAllEventHandlers "Hit";
	_IED removeAllEventHandlers "MPHit";
	_IED removeAllEventHandlers "Killed";
	_IED removeAllEventHandlers "MPKilled";
	[_ied] call reezo_eod_fnc_detonation;
};

_damage = _damage / 10;

_damage