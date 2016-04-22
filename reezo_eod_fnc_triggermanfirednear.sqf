// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};

private ["_triggerman","_firer","_distance","_rnd"];
_triggerman = _this select 0;
_firer = _this select 1;
_distance = _this select 2;

_rnd = random 1;

if (_distance > 300 OR side _firer == side _triggerman OR _rnd < 0.5) exitWith {};

_rnd = random 1;

switch (true) do {
	case (_rnd < 0.33) : {
		_triggerman removeAllEventHandlers "firednear";
		_triggerman playMoveNow "AmovPercMstpSsurWnonDnon";
		_triggerman disableAI "ANIM";
		_triggerman disableAI "MOVE";
	};
	case (_rnd > 0.33 && _rnd < 0.66) : {
		_triggerman removeAllEventHandlers "firednear";
		_rnd = random 1;
		if (_rnd < 0.5) then {
			_triggerman addMagazine "8Rnd_9x18_Makarov";
			_triggerman addMagazine "8Rnd_9x18_Makarov";
			_triggerman addWeapon "Makarov";
		} else {
			_triggerman addMagazine "30Rnd_9x19_UZI";
			_triggerman addMagazine "30Rnd_9x19_UZI";
			_triggerman addWeapon "UZI_EP1";
		};
		_triggerman addRating -1000;
		_triggerman setBehaviour "COMBAT";
		_triggerman setCombatMode "RED";
		_triggerman setUnitPos "MIDDLE";
		_triggerman doTarget _firer;
		true = _triggerman fireAtTarget [_firer,currentWeapon _triggerman];
	};
	case (_rnd > 0.66) : {
		_triggerman removeAllEventHandlers "firednear";
		
		_rnd = random 1;
		if (_rnd < 0.5) then {
			_triggerman addMagazine "8Rnd_9x18_Makarov";
			_triggerman addMagazine "8Rnd_9x18_Makarov";
			_triggerman addWeapon "Makarov";
		} else {
			_triggerman addMagazine "30Rnd_9x19_UZI";
			_triggerman addMagazine "30Rnd_9x19_UZI";
			_triggerman addWeapon "UZI_EP1";
		};
		_triggerman addRating -1000;
		
		private ["_group","_segno","_escapePos","_posX","_posY"];
		_group = group _triggerman;
		_segno = random 1; if (_segno < 0.5) then { _posX = 300 + random 300 } else { _posX = 300 - random 300 };
		_segno = random 1; if (_segno < 0.5) then { _posY = 300 + random 300 } else { _posY = 300 - random 300 };
		_escapePos = [_posX,_posY];

		deleteWaypoint [_group, 0];
		deleteWaypoint [_group, 1];
		deleteWaypoint [_group, 2];
		deleteWaypoint [_group, 3]; 
		
		_group addWaypoint [_escapePos, 0];
		[_group, 0] setWaypointType "MOVE";
		[_group, 0] setWaypointBehaviour "SAFE";
		[_group, 0] setWaypointSpeed "FULL";       
		
	};
};

