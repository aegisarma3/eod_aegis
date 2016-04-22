// IED Detection and Disposal Mod
// 2011 by Reezo

private ["_caller","_range","_rangeMin","_rangeMax","_probability","_interval","_object","_id"];
_caller = _this select 1;;
if !(local _caller) exitWith{};
_object = _this select 0;
_id = _this select 2;
_range = (_this select 3) select 1;
if (count _range != 2) exitWith{};
_rangeMin = _range select 0;
_rangeMax = _range select 1;
_probability = (_this select 3) select 2;
_interval = (_this select 3) select 3;

//hintSilent format["OBJECT:\n%1\nCALLER:\n%2\nRANGE:\n%3\nPROBABILITY:\n%4\nINTERVAL:\n%5",_object,_caller,_range,_probability,_interval];

private ["_rnd"];
_rnd = random 1;
if (_rnd < 0.5) then {
	[_object, "reezo_eod_sound_evacuate"] call CBA_fnc_globalSay3d;
} else {
	[_object, "reezo_eod_sound_evacuate02"] call CBA_fnc_globalSay3d;
};

_object removeaction _id;
_object removeaction (_id - 1);

private ["_nearMen", "_i","_thisMan","_civGroup","_segno","_posX","_posY","_evacuatePos"];
_nearMen = (getPos _object) nearEntities ["Man",_rangeMin];
  for "_y" from 0 to (count _nearMen - 1) do {

	_thisMan = _nearMen select _y;
    _civGroup = group _thisMan;

	if (side _thisMan == CIVILIAN && _thisMan == leader (group _thisMan) && isNil {_thisMan getVariable "reezo_ied_triggerman"} && isNil {_thisMan getVariable "reezo_ied_trigger"}) then {

		_rnd = random 1;

		if (_rnd < _probability) then {
			{
			_x setSkill 0;
			_x setBehaviour "SAFE";
			_x setSpeedMode "NORMAL";
			} forEach (units _civGroup);

			_segno = random 1;
			if (_segno < 0.5) then { _posX = _rangeMin + _rangeMax } else { _posX = _rangeMin - _rangeMax };
			_segno = random 1;
			if (_segno < 0.5) then { _posY = _rangeMin + _rangeMax } else { _posY = _rangeMin - _rangeMax };

			_evacuatePos = [_posX,_posY];

			{ deleteWaypoint _x } forEach (waypoints _civGroup);

			_civGroup addWaypoint [_evacuatePos, 1];
			[_civGroup, 1] setWaypointType "MOVE";
			[_civGroup, 1] setWaypointBehaviour "SAFE";
			[_civGroup, 1] setWaypointSpeed "FULL";

			//hintSilent format["%1\n\n%2\n\n%3\n\n%4\n\n%5",_object,_caller,_thisMan,_civGroup,_evacuatePos];
		};
	};
};

sleep _interval;

waitUntil {!(isNull _caller)};
waitUntil {_caller == _caller};
waitUntil {alive _caller};

nul0 = [_caller,_range,_probability,_interval] execVM "\eod\reezo_eod_action_add_loudspeaker.sqf";

if (true) exitWith{};
