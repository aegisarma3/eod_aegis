// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};

private ["_soldier","_ied","_trigger","_near","_rnd","_det"];
_soldier = _this select 0;
_ied = _this select 1;
_rangeMax = _this select 2;
_det = false;

waitUntil {!(isNull _ied)};
waitUntil {_ied == _ied};

_ied addeventhandler ["HandleDamage","_this call reezo_eod_fnc_iedDamage"];

if (isNil {_ied getVariable "reezo_eod_jammed"}) then { _ied setVariable ["reezo_eod_jammed",false] };

waitUntil {!(_ied getVariable "reezo_eod_jammed")};

if (isNil {_ied getVariable "reezo_eod_trigger"}) then
{
	_rnd = random 100;
	_trigger = "vehicle";
	_ied setVariable ["reezo_eod_trigger","vehicle"];

	switch (true) do {
		case (_rnd < 33) : {
			_trigger = "infantry";
			_ied setVariable ["reezo_eod_trigger","infantry"];
		};
		case (_rnd > 66) : {
			_trigger = "radio";
			_ied setVariable ["reezo_eod_trigger","radio"];
		};
	};

} else
{
	_trigger = _ied getVariable "reezo_eod_trigger";
};

if (_trigger == "radio") then
{
	private ["_group","_skins","_triggerman"];
	_group = createGroup civilian;
	_skins = ["C_man_1","C_man_polo_2_F","C_man_polo_5_F","C_man_polo_6_F","C_man_1_3_F","C_man_p_fugitive_F","C_man_polo_4_F"];
	_triggerman = _group createVehicle [_skins select (floor (random (count _skins))), getPos _ied, [], 100, "NONE"];
	waitUntil {!isNull _triggerman};
	waitUntil {alive _triggerman};

	_ied setVariable ["reezo_eod_triggerman",_triggerman];
	waitUntil { !isNil {_ied getVariable "reezo_eod_triggerman"} };

	_ied setVariable ["reezo_eod_jammed",false];
	waitUntil { !isNil {_ied getVariable "reezo_eod_jammed"} };

	_triggerman setVariable ["reezo_eod_triggerman",true];
	waitUntil { !isNil {_triggerman getVariable "reezo_eod_triggerman"} };

	removeAllItems _triggerman;
	removeAllWeapons _triggerman;

	_triggerman addWeapon "Binocular";
	_triggerman addWeapon "ItemRadio";
	_triggerman doWatch (getPos _ied);
	_triggerman addEventHandler ["firednear", "_this call reezo_eod_fnc_triggermanfirednear"];
};

while {alive _ied} do
{
	switch (_trigger) do
	{
		case "infantry" :
		{
			_det = [_ied,_trigger] call reezo_eod_fnc_pressureDetection;
			if (_det) exitWith { [_ied] call reezo_eod_fnc_detonation };
		};
		case "vehicle" :
		{
			_det = [_ied,_trigger] call reezo_eod_fnc_pressureDetection;
			if (_det) exitWith { [_ied] call reezo_eod_fnc_detonation };
		};
		case "radio" :
		{
			if !(alive _triggerman OR isNull (_ied getVariable "reezo_eod_triggerman")) exitWith {};
			_det = [_ied] call reezo_eod_fnc_triggerDetection;
			if (_det) exitWith { [_ied] call reezo_eod_fnc_detonation };
		};
	};

	//If no units from the soldier group are in the _rangeMax distance, remove the IED and its triggerman (if present)
	private ["_clean"];
	_clean = true;
	for "_i" from 0 to ((count (units (group _soldier))) - 1) do
	{
		if (_ied distance ((units (group _soldier)) select _i) < _rangeMax) then
		{
			_clean = false;
		};
	};

	if (_clean) then //Remove the IED and its triggerman
	{
		if (_trigger == "radio") then { deleteVehicle (_ied getVariable "reezo_eod_triggerman") };
		deleteVehicle _ied;
	};

	sleep 2;
};

_soldier setVariable ["reezo_eod_avail",true];
