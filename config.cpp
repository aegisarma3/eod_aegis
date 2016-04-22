class CfgPatches
{
	class reezo_eod
	{
		units[] = { };
		weapons[] = { };
		requiredVersion = 0.1;
		requiredAddons[] = {"Extended_Eventhandlers", "ace_main"};
		version = "220";
		author[] = {
				"Reezo"
		};
	};
};

class CfgAddons
{

	class PreloadAddons
	{
		class reezo_eod
		{
			list[] = {
					"reezo_eod"
			};
		};
	};
};

class Extended_PreInit_EventHandlers
{
	class reezo_eod
	{
		serverInit = "call compile preProcessFileLineNumbers '\eod\XEH_preServerInit.sqf'";
	};
};

class Extended_InitPost_EventHandlers
{
	class Land_IED_v1_PMC
	{
		serverInit = "nul0 = [this] execVM '\eod\IED_postServerInit.sqf'";
	};
};


class cfgSounds
{
	class reezo_eod_sound_beep
	{
		name = "reezo_eod_sound_beep";
		sound[] = {"\eod\sounds\reezo_eod_sound_beep.ogg", db-18, 1.0};
		titles[] = {};
	};
	class reezo_eod_sound_beep02
	{
		name = "reezo_eod_sound_beep02";
		sound[] = {"\eod\sounds\reezo_eod_sound_beep02.ogg", db-18, 1.0};
		titles[] = {};
	};
	class reezo_eod_sound_akbar
	{
		name = "reezo_eod_sound_akbar";
		sound[] = {"\eod\sounds\reezo_eod_sound_akbar.ogg", db-9, 1.0};
		titles[] = {};
	};
	class reezo_eod_sound_evacuate
	{
		name = "reezo_eod_sound_evacuate";
		sound[] = {"\eod\sounds\reezo_eod_sound_evacuate.ogg", db-3, 1.0};
		titles[] = {};
	};
	class reezo_eod_sound_evacuate02
	{
		name = "reezo_eod_sound_evacuate02";
		sound[] = {"\eod\sounds\reezo_eod_sound_evacuate02.ogg", db-3, 1.0};
		titles[] = {};
	};
};

class cfgVehicles
{
	class Logic ;

	class reezo_eod_iedarea : Logic
	{
		displayName = "(EOD) IED Area";
		icon = "\eod\data\icon_iedarea_ca.paa";
		picture = "\eod\data\icon_iedarea_ca.paa";
		vehicleClass = "Modules";

		class Eventhandlers
		{
			init = "private [""_ok""]; _ok = (_this select 0) execVM ""\eod\reezo_eod_module_iedarea.sqf""";
		};
	};
	class reezo_eod_suicarea : Logic
	{
		displayName = "(EOD) Suicide Bomber Area";
		icon = "\eod\data\icon_suicarea_ca.paa";
		picture = "\eod\data\icon_suicarea_ca.paa";
		vehicleClass = "Modules";

		class Eventhandlers
		{
			init = "private [""_ok""]; _ok = (_this select 0) execVM ""\eod\reezo_eod_module_suicarea.sqf""";
		};
	};
	class reezo_eod_ambied : Logic
	{
		displayName = "(EOD) Ambient IEDs";
		icon = "\eod\data\icon_ambied_ca.paa";
		picture = "\eod\data\icon_ambied_ca.paa";
		vehicleClass = "Modules";

		class Eventhandlers
		{
			init = "private [""_ok""]; _ok = (_this select 0) execVM ""\eod\reezo_eod_module_ambied.sqf""";
		};
	};
	class reezo_eod_ambsuic : Logic
	{
		displayName = "(EOD) Ambient Suicide Bombers";
		icon = "\eod\data\icon_ambsuic_ca.paa";
		picture = "\eod\data\icon_ambsuic_ca.paa";
		vehicleClass = "Modules";

		class Eventhandlers
		{
			init = "private [""_ok""]; _ok = (_this select 0) execVM ""\eod\reezo_eod_module_ambsuic.sqf""";
		};
	};
	class reezo_eod_loudspeaker : Logic
	{
		displayName = "(EOD) Loudspeaker";
		icon = "\eod\data\icon_loudspeaker_ca.paa";
		picture = "\eod\data\icon_loudspeaker_ca.paa";
		vehicleClass = "Modules";

		class Eventhandlers
		{
			init = "private [""_ok""]; _ok = (_this select 0) execVM ""\eod\reezo_eod_module_loudspeaker.sqf""";
		};
	};
};

class cfgWeapons
{
	class RifleCore ;

	class LauncherCore ;

	class PistolCore ;

	class Default ;

	class launcher : launcherCore {};

	class ACE_rucksack : launcher {};

	class ACE_CharliePack : ACE_rucksack {};

	class ACE_PRC119 : ACE_CharliePack {};

	class SR5_THOR3 : ACE_PRC119
	{
		displayName = "THOR III";
		model = "\x\ace\addons\sys_ruck\backpack_data\charliepack_green_prc119.p3d";
		picture = "\eod\data\w_thor3_ca.paa";
		//picture = "\x\ace\addons\sys_ruck\data\equip\w_charlie_radio_ca.paa";
		descriptionShort = "SNC ACM THOR III IED Dismount Jammer | Green";
		ACE_PackSize = 21810;
		ACE_Size = 21811;
		ACE_Weight = 7;
		ACE_is_radio = 0;
	};

	class SR5_THOR3_MAR : SR5_THOR3
	{
		model = "\x\ace\addons\sys_ruck\backpack_data\charliepack_wmarpat_prc119.p3d";
		picture = "\eod\data\w_thor3_wm_ca.paa";
		//picture = "\x\ace\addons\sys_ruck\data\equip\w_charlie_wm_radio_ca.paa";
		descriptionShort = "SNC ACM THOR III IED Dismount Jammer | Marpat W";
	};

	class SR5_THOR3_ACU : SR5_THOR3
	{
		model = "\x\ace\addons\sys_ruck\backpack_data\charliepack_acu_prc119.p3d";
		picture = "\eod\data\w_thor3_acu_ca.paa";
		//picture = "\x\ace\addons\sys_ruck\data\equip\w_charlie_acu_radio_ca.paa";
		descriptionShort = "SNC ACM THOR III IED Dismount Jammer | ACU";
	};
};
