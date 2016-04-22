// IED Detection and Disposal Mod
// 2011 by Reezo

if (!isServer) exitWith{};

private ["_soldier","_bomber","_rangeMax","_victims", "_i", "_risk", "_victim"];
_soldier = _this select 0;
_bomber = _this select 1;
_rangeMax = _this select 2;
_risk = 0;
_victims = [];
_victim = objNull;

private ["_near"];
_near = getPos _bomber nearEntities [["Man", "Car", "Tank"], 50];

if (count _near > 0) then //If some units/objects are near we get how many of them are suitable victims
{
	for "_i" from 0 to (count _near - 1) do
	{
		private ["_thisNear","_friendly"];
		_thisNear = _near select _i;
		_friendly = EAST getFriend side _thisNear;
		
		if (_friendly < 0.6 && _bomber knowsAbout _thisNear > 0.2) then { //Near units are victims only if enemy, known and close enough
			_victims set [count _victims, _thisNear];
		};
	};
};

//In case no victims are found in maximum range, we delete the suicide bomber
if (count _victims == 0) then
{
	private ["_clean"];
	_clean = true;
	
	for "_i" from 0 to (count (units (group _soldier)) - 1) do
	{
		private ["_thisUnit"];
		_thisUnit = (units (group _soldier)) select _i;
		
		if (_bomber distance _thisUnit < _rangeMax) then
		{
			_clean = false;
		};
	};
	
	if (_clean) exitWith
	{
		//player globalChat format["CLEANING UP THIS SUICIDE BOMBER: %1 BECAUSE IT IS TOO FAR", _bomber];

		_soldier setVariable ["reezo_eod_avail",true];
		deleteVehicle _bomber;
		_victim
	};
};

//At this point, we have some victims and we calculate the risk to make the suicide bomber detonate
for "_i" from 0 to (count _victims - 1) do
{
	switch (true) do {
		case ((_victims select _i) isKindOf "Man") : {
			_risk = _risk + 5;
		};
		case ((_victims select _i) isKindOf "Car") : {
			_risk = _risk + 20;
		};
		case ((_victims select _i) isKindOf "Tank") : {
			_risk = _risk + 30;
		};
	};
};

//We take the risk
_rnd = random 100;
if (_rnd < _risk) then
{
	_victim = _victims select (floor (random (count _victims))); //We pick the victim
};

//player globalChat format["%1 RISK FACTOR: %2",_bomber, _risk];

_victim
