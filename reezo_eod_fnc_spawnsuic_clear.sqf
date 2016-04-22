// IED Detection and Disposal Mod
// 2011 by Reezo

if !(isServer) exitWith{};

private ["_soldier","_rangeMax","_near"];
_soldier = _this select 0;
_rangeMax = _this select 1;
_near = getPos _soldier nearEntities ["Man", _rangeMax * 2];

private ["_i","_j"];
for "_i" from 0 to (count _near - 1) do
{
	private ["_thisMan"];
	if (
	switch (isNil {(_near select _i) getVariable "reezo_eod_trigger"}) do
	{
		case true : {}; //Not a suicide bomber
		
		case false : {		
			//OBJECT IS IED OR SUICIDE BOMBER..BUT IS IT FAR ENOUGH FOR CLEANING UP?
			if (_soldier distance (_near select _i) > _rangeMax) then {
				_nearSynced = nearestObjects [(_near select _i), ["Man"], _rangeMax];
		
				for "_j" from 0 to (count _nearSynched - 1) do {
					if ((_nearSynched select _j) getVariable "reezo_eod_synced_ambsuic") exitWith {
						//diag_log format["reezo_eod_fnc_spawnsuic_clear - %1 IS CLOSE TO ANOTHER SYNCED: %2",_near select _i, _nearSynched select _j];
					};
				};
			} else {
				//diag_log format["reezo_eod_fnc_spawnsuic_clear - %1 IS STILL CLOSE TO %2",_near select _i, _soldier];	
			};
		};
		
		//diag_log format["reezo_eod_fnc_spawnsuic_clear - CLEARING THIS BOMBER: %1",_near select _i];
		deleteVehicle _near select _i;
		
	};
};