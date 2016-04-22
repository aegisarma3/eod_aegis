// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};

private ["_triggerman","_nearestEnemy","_rnd"];
_triggerman = _this select 0;

if (animationState _triggerman == "AmovPercMstpSsurWnonDnon" OR _triggerman hasWeapon "hgun_P07_F" OR _triggerman hasWeapon "hgun_PDW2000_F") exitWith {};

_nearestEnemy =  if (count _this == 2) then { _this select 1 } else { _triggerman findNearestEnemy (getPos _triggerman) }; //Find the nearest enemy to the triggerman

_rnd = random 1;
_triggerman removeAllEventHandlers "firednear";

switch (true) do
{
	case (_rnd < 0.10) : //Surrenders
	{
		_triggerman playMoveNow "AmovPercMstpSsurWnonDnon";
		_triggerman disableAI "ANIM";
		_triggerman disableAI "MOVE";

		//player globalChat "REACTION: SURRENDER";
	};

	case (_rnd > 0.10 && _rnd < 0.55) : //Fights..
	{

		_triggerman enableAI "ANIM";
		_triggerman enableAI "MOVE";
		_triggerman enableAI "TARGET";
		_triggerman enableAI "AUTOTARGET";

		_rnd = random 1;

		if (_rnd < 0.5) then
		{
			_triggerman addMagazine "16Rnd_9x21_Mag"; //..with a hgun_P07_F
			_triggerman addMagazine "16Rnd_9x21_Mag";
			_triggerman addWeapon "hgun_P07_F";
		    _triggerman selectWeapon "hgun_P07_F";

		} else
		{
			_triggerman addMagazine "30Rnd_9x21_Mag"; //..with an UZI
			_triggerman addMagazine "30Rnd_9x21_Mag";
			_triggerman addWeapon "hgun_PDW2000_F";
		    _triggerman selectWeapon "hgun_PDW2000_F";
		};

		_triggerman addRating -1000;

		_triggerman setBehaviour "COMBAT";
		_triggerman setCombatMode "RED";
		_triggerman setUnitPos "MIDDLE";

		if (!isNull _nearestEnemy) then
		{
			_triggerman doTarget _nearestEnemy;
			nul0 = _triggerman fireAtTarget [_nearestEnemy, currentWeapon _triggerman];
		};

		//player globalChat format["REACTION: FIGHT WITH %1 AGAINST %2",currentWeapon _triggerman, _nearestEnemy];
	};

	case (_rnd > 0.55) : //Runs away..
	{
		_triggerman enableAI "ANIM";
		_triggerman enableAI "MOVE";
		_triggerman enableAI "TARGET";
		_triggerman enableAI "AUTOTARGET";

		_rnd = random 1;

		if (_rnd < 0.5) then
		{
			_triggerman addMagazine "16Rnd_9x21_Mag"; //..with a hgun_P07_F
			_triggerman addMagazine "16Rnd_9x21_Mag";
			_triggerman addWeapon "hgun_P07_F";
		    _triggerman selectWeapon "hgun_P07_F";
		} else {
			_triggerman addMagazine "30Rnd_9x21_Mag"; //..with an UZI
			_triggerman addMagazine "30Rnd_9x21_Mag";
			_triggerman addWeapon "hgun_PDW2000_F";
		    _triggerman selectWeapon "hgun_PDW2000_F";
		};

		_triggerman addRating -1000;

		private ["_grp"];
		_grp = group _triggerman;

		private ["_wp"];
		_wp = _grp addWaypoint [getPos _triggerman, 800];

		_wp setWaypointType "MOVE";
		_wp setWaypointBehaviour "SAFE";
		_wp setWaypointSpeed "FULL";
		_wp setWaypointStatements ["true", "_triggerman setUnitPos ""MIDDLE"""];
		_grp setCurrentWaypoint _wp;

		//player globalChat format["REACTION: ESCAPE WITH %1 TO DESTIONATION: %2",currentWeapon _triggerman, getWPPos _wp];
	};
};
