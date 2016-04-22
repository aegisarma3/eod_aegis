// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};

private ["_soldier", "_rangeMin", "_rangeMax"];
_soldier = _this select 0;

private ["_nearCivs"];
_nearCivs = [];

_rangeMin = (_this select 1) select 0;
_rangeMax = (_this select 1) select 1;

//Tell me how many "Men" are near the soldier between _RangeMIN and _RangeMAX
private ["_near", "_i"];
_near = (getPos _soldier) nearEntities ["Man", _rangeMax];
if (_soldier in _near) then { _near = _near - [_soldier] };

//Tell me how many civilians are among the near men
if (count _near > 0) then
{
	for "_i" from 0 to (count _near - 1) do
	{
		private ["_thisNear"];
		_thisNear = _near select _i;

		if (_thisNear getVariable "reezo_eod_trigger" == "suicide") exitWith {}; //If a suicide bomber is already in the area, exit

		if (_thisNear distance _soldier > _rangeMin && side _thisNear == CIVILIAN) then
		{
			_nearCivs set [count _nearCivs, _thisNear]; //Create an array made only of nearby civilians
		};
	};
};

//Pick one of the existing civilians if found in a suitable area
if (count _nearCivs > 0) exitWith
{
	private ["_bomber"];
	_bomber = _nearCivs select (floor (random (count _nearCivs)));

	nul0 = [_bomber] execVM "\eod\reezo_eod_suicidebomber.sqf";
};

//At this point no suitable civilian was found and we are going to spawn one, specifically to make it a suicide bomber
private ["_grp","_skins","_bomber"];
_grp = createGroup CIVILIAN;
_skins = ["C_man_1","C_man_polo_2_F","C_man_polo_5_F","C_man_polo_6_F","C_man_1_3_F","C_man_p_fugitive_F","C_man_polo_4_F"];
_bomber = _grp createvehicle [(_skins select (floor (random (count _skins)))), getPos _soldier, [], _rangeMax, "NONE"];

//Let's run the Suicide Bomber behaviour script and then exit
nul0 = [_triggerman] execVM "\eod\reezo_eod_suicidebomber.sqf";
