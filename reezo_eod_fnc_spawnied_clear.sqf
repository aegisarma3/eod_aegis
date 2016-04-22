// IED Detection and Disposal Mod
// 2011 by Reezo

private ["_soldier","_rangeMax","_nearIED","_nearSynced"];
_soldier = _this select 0;
_rangeMax = _this select 1;
_nearIED = nearestObjects [_soldier, ["Land_IED_v1_PMC","Land_IED_v2_PMC","Land_IED_v3_PMC","Land_IED_v4_PMC"], _rangeMax * 2];

private ["_i","_j"];
for "_i" from 0 to (count _nearIED - 1) do
{
	switch (isNil {(_nearIED select _i) getVariable "reezo_eod_trigger"}) do
	{
		case true :
		{	
			//OBJECT IS NOT AN IED OR SUICIDE BOMBER
			//diag_log format["reezo_eod_fnc_spawnied_clear - %1 IS NOT MOD-RELATED OR CLOSE",_nearIED select _i];		
		};
		
		case false :
		{	
			//OBJECT IS IED OR SUICIDE BOMBER..BUT IS IT FAR ENOUGH FOR CLEANING UP?
			if (_soldier distance (_nearIED select _i) > _rangeMax) then
			{
				_nearSynced = nearestObjects [(_nearIED select _i), ["Man"], _rangeMax];
		
				for "_j" from 0 to (count _nearSynched - 1) do {
					if ((_nearSynched select _j) getVariable "reezo_eod_synced_ambsuic") exitWith {
						//diag_log format["reezo_eod_fnc_spawnied_clear - %1 IS CLOSE TO ANOTHER SYNCED: %2",_nearIED select _i, _nearSynched select _j];
					};
				};
				
			} else
			{
				//diag_log format["reezo_eod_fnc_spawnied_clear - %1 IS STILL CLOSE TO %2",_nearIED select _i, _soldier];	
			};
		};
		
		//diag_log format["reezo_eod_fnc_spawnied_clear - CLEARING THIS BOMBER: %1",_nearIED select _i];
		deleteVehicle _nearIED select _i;
		
	};
};