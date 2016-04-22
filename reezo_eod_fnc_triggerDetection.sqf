// IED Detection and Disposal Mod
// 2011 by Reezo

//Initialising detonation value as false
private ["_det","_rnd"];
_det = false;

if (!isServer) exitWith {_det}; //Exiting in case of not being the server

private ["_ied","_triggerman"];
_ied = _this select 0;
_triggerman = _ied getVariable "reezo_eod_triggerman";

//Exit if triggerman surrendered, does not exist or decided to flee/fight against the players
if (isNull _triggerman OR animationState _triggerman == "AmovPercMstpSsurWnonDnon" OR _triggerman hasWeapon "Makarov" OR _triggerman hasWeapon "UZI_EP1") exitWith
{
	//player globalChat "TRIGGERMAN TOO DAMAGED OR FIGHTING OR SURRENDERED ALREADY";
	_det
};

//Triggerman reacts if enemy units are too close to him
private ["_near"];
_near = getPos _triggerman nearEntities ["Man", 7];
if (count _near > 0 && animationState _triggerman != "AmovPercMstpSsurWnonDnon") then
{
	for "_i" from 0 to (count _near - 1) do
	{
		private ["_thisNear","_friendly"];
		_thisNear = _near select _i; //Get the specific unit near the triggerman
		_friendly = EAST getFriend side _thisNear; //Get how friendly the unit side is to the OPFOR
		if (_friendly < 0.6 && currentWeapon _thisNear != "" && _triggerman knowsAbout _thisNear > 0.1 && abs(((getPos _triggerman) select 2) - ((getPos _thisNear) select 2)) < 5) exitWith 
		{
			//player globalChat "TRIGGERMAN CHOOSES TO REACT";
			[_triggerman, _thisNear] call reezo_eod_fnc_triggermanreact;
			_det
		};
	};
};

//Check if the IED is jammed or not
private ["_skill","_thors"];
_skill = 0;
_thors = [];

private ["_near"];
_near = getPos _ied nearEntities ["Man", 100]; //Get how many units are in jamming range of the IED
for "_i" from 0 to (count _near - 1) do
{
	private ["_thisNear"];
	_thisNear = _near select _i;
	if (secondaryWeapon _thisNear in ["SR5_THOR3", "SR5_THOR3_MAR", "SR5_THOR3_ACU"]) then //Get if the nearby unit has a THOR 3 JAMMER
	{		
		_nearVeh = getPos _thisNear nearEntities [["Car", "Tank"], 10]; //If this unit has the jammer but is close to a vehicle, the jammer will not work properly
		if (count _nearVeh > 0 ) then
		{
			_skill = _skill - (random 20); //Reduce jamming skill randomly
		};

		_thors set [count _thors, _thisNear]; //Calculate the total amount of THOR 3 JAMMER presents
	};
};

_skill = _skill + ((count _thors) * 20);  //Increase jamming skill for each THOR 3 JAMMER

//Act depending on the IED being jammed or not
switch (_ied getVariable "reezo_eod_jammed") do
{
	case false :
	{
		_rnd = random 100;
		if (_rnd < _skill) exitWith
		{
			_ied setVariable ["reezo_eod_jammed",true]; //Tag the IED as jammed

			{
				[_x, "reezo_eod_sound_beep"] call CBA_fnc_globalSay3d; //Play a beep sound in each Thor 3 Jammer taking part to the jam
			} forEach _thors;

			//player globalChat "NOW JAMMED";

			_det 
		};
	};
	case true :
	{
		if (count _thors > 0) exitWith
		{
			{
				[_x, "reezo_eod_sound_beep02"] call CBA_fnc_globalSay3d; //Play a beep sound in each Thor 3 Jammer taking part to the jam
			} forEach _thors;
			
			//player globalChat "KEEPING JAMMED";
			
			_det
		};
	};
};

//Make sure script exits if IED is jammed or triggerman is too far from the IED
if (_ied getVariable "reezo_eod_jammed" OR _triggerman distance _ied > 250) exitWith
{
	//player globalChat "TRIGGERMAN TOO FAR OR IED JAMMED";
	
	_det
};


//Since at this point the IED is not jammed, the triggerman considers blowing the bomb up, depending on how many victims he finds near the IED
private ["_near"];
_near = (getPos _ied) nearEntities [["Man", "Car", "Tank"], 15];

//If no victims at all are found, script exits
if (count _near == 0) exitWith
{
	//player globalChat format["NO NEAR %1",_triggerman];
	_det
};

//At this point some victims were found, so let's calculate how convenient it is to blow the bomb up
private ["_risk"];
_risk = 0;

for "_i" from 0 to (count _near - 1) do
{
	private ["_thisNear"];
	_thisNear = _near select _i;
	if (_triggerman knowsAbout _thisNear > 0.1) then //Only evaluate victim possibility if triggerman KNOWS about the victim, even a little
	{	
		private ["_friendly"];
		_friendly = EAST getFriend (side _thisNear); //Get how friendly the victim is to the OPFOR side
	
		switch (_friendly < 0.6) do
		{
			case true : { //Victim is enemy, this motivates the trigger to ACTUALLY blow the bomb up
				switch (true) do
				{
					case ((_thisNear) isKindOf "Man") : { 
						_risk = _risk + 10;
					};
					case ((_thisNear) isKindOf "Car") : {
						_risk = _risk + 25;
					};
					case ((_thisNear) isKindOf "Tank") : {
						_risk = _risk + 50;
					};
				};
			};
			case false : { //Victim is friendly, this motivates the triggerman NOT to blow up the bomb
				switch (true) do
				{
					case ((_thisNear) isKindOf "Man" && (_thisNear) != _triggerman) : {
						_risk = _risk - 5;
					};
					case ((_thisNear) isKindOf "Car") : {
						_risk = _risk - 12.5;
					};
					case ((_thisNear) isKindOf "Tank") : {
						_risk = _risk - 25;
					};
				};
			};
		};
	};
};

_rnd = random 100;

if (_rnd < _risk && damage _triggerman < 0.5 && alive _ied) then
{
	//player globalChat "TRIGGERMAN DETONATES!";
	
	[_triggerman, "reezo_eod_sound_akbar"] call CBA_fnc_globalSay3d;
	sleep 2;
	
	private ["_nearestEnemy"];
	_nearestEnemy = _triggerman findNearestEnemy (getPos _triggerman);
	
	[_triggerman, _nearestEnemy] call reezo_eod_fnc_triggermanreact;
	
	_det = true;
};

//player globalChat format["VICTIM IS %1 - IS ENEMY? %2 - CURRENT RISK: %3 - TRIGGERMAN: %4 - ENEMY: %5", typeOf _thisNear, (_friendly < 0.6), _risk, _triggerman, _nearestEnemy];

_det