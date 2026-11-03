class CfgPatches {
	class Bro_ModularWarehouse_Remastered {
		name = "Modular Warehouse Remastered [Bromine]";
		author = "Bromine";
		url = "https://steamcommunity.com/id/Brominum/";
		requiredAddons[] = {"A3_Data_F_Decade_Loadorder"};
		requiredVersion = 1.60;
	};
};
class CfgAnimationSourceSounds {
	class Bro_GarageSound {
		class DoorMovement {
			loop=0;
			terminate=1;
			trigger="(phase factor[0.05,0.10]) * (phase factor[0.95,0.9])";
			sound0[]= {
				"Bro_Modular_Warehouse\remaster\sound\garagedoor.ogg",
				1,
				1,
				35
			};
			sound[]= {"sound0",1};
		};
		class DoorMovementDone {
			loop=0;
			terminate=0;
			trigger="direction * (phase factor[0.98,0.99])";
			sound0[]= {
				"A3\Sounds_F\environment\structures\doors\RollDoors\RollDoorsSlam_1",
				1,
				1,
				35
			};
			sound1[]= {
				"A3\Sounds_F\environment\structures\doors\RollDoors\RollDoorsSlam_2",
				1,
				1,
				35
			};
			sound[]= {
				"sound0",
				0.5,
				"sound1",
				0.5
			};
		};
		class OpenTheDoor {
			loop=0;
			terminate=0;
			trigger="(phase factor[0.01,0.02])";
			sound0[]= {
				"A3\Sounds_F\environment\structures\doors\RollDoors\RollDoorsKnob_1",
				1,
				1,
				35
			};
			sound1[]= {
				"A3\Sounds_F\environment\structures\doors\RollDoors\RollDoorsKnob_2",
				1,
				1,
				35
			};
			sound[]= {
				"sound0",
				0.5,
				"sound1",
				0.5
			};
		};
		class SlamTheDoor {
			loop=0;
			terminate=0;
			trigger="(phase factor[0.1,0.09])";
			sound0[]= {
				"A3\Sounds_F\environment\structures\doors\RollDoors\RollDoorsSlam_1",
				1,
				1,
				35
			};
			sound1[]= {
				"A3\Sounds_F\environment\structures\doors\RollDoors\RollDoorsSlam_2",
				1,
				1,
				35
			};
			sound[]= {
				"sound0",
				0.5,
				"sound1",
				0.5
			};
		};
	};
};
class CfgEditorCategories {
	class Bro_MWH_Base {
		displayName = "Modular Warehouse [Bromine]";
	};
};
class CfgEditorSubcategories {
	class Bro_MWHR_Wall {
		displayName = "New Walls";
	};
	class Bro_MWHR_Roof {
		displayName = "New Roofs";
	};
	class Bro_MWHR_Floor {
		displayName = "New Floors";
	};
};
class CfgFunctions  {
	class bro  {
		class mwh_new {
			file = "\Bro_Modular_Warehouse\remaster\functions";
			class snap_warehouse{};
		};
	};
};
class CfgVehicles {
	class House;
	class House_F: House {
		class EventHandlers;
	};
	class Land_Bro_MWHR_Base: House_f {
		scope = 0;
		scopeCurator = 0;
		author = "Bromine";
		editorCategory = "Bro_MWH_Base";
		icon = "Bro_Modular_Warehouse\remaster\icon_ca.paa";
		editorSubcategory = "Bro_MWHR_Wall";
		destrType = "DestructNo";
		mapSize = 5;
		keepHorizontalPlacement = 1;
		numberOfDoors = 0;
		class EventHandlers: EventHandlers {
			dragged3DEN = "_this call bro_fnc_snap_warehouse;";
			registeredToWorld3DEN = "_this call bro_fnc_snap_warehouse;";
		};
	};
	class Land_Bro_MWHR_Plain: Land_Bro_MWHR_Base {
		scope = 2;
		scopeCurator = 2;
		displayName = "WH Wall: Plain";
		model = "Bro_Modular_Warehouse\remaster\bro_mwhr_plain.p3d";
		editorPreview = "Bro_Modular_Warehouse\remaster\thumbs\Land_Bro_MWHR_Plain.jpg";
	};
	class Land_Bro_MWHR_Plaint_Int: Land_Bro_MWHR_Plain {
		scope = 2;
		scopeCurator = 2;
		displayName = "WH Wall: Plain, Interior";
		model = "Bro_Modular_Warehouse\remaster\bro_mwhr_plain_int.p3d";
		editorPreview = "Bro_Modular_Warehouse\remaster\thumbs\Land_Bro_MWHR_Plain.jpg";
	};
	class Land_Bro_MWHR_Corner: Land_Bro_MWHR_Plain {
		scope = 2;
		scopeCurator = 2;
		displayName = "WH Wall: Corner Endcap";
		model = "Bro_Modular_Warehouse\remaster\bro_mwhr_corner.p3d";
		editorPreview = "Bro_Modular_Warehouse\remaster\thumbs\Land_Bro_MWHR_Corner.jpg";
	};
	class Land_Bro_MWHR_Window: Land_Bro_MWHR_Plain {
		scope = 2;
		scopeCurator = 2;
		displayName = "WH Wall: Window";
		model = "Bro_Modular_Warehouse\remaster\bro_mwhr_window.p3d";
		editorPreview = "Bro_Modular_Warehouse\remaster\thumbs\Land_Bro_MWHR_Window.jpg";
	};
	class Land_Bro_MWHR_Door: Land_Bro_MWHR_Plain {
		scope = 2;
		scopeCurator = 2;
		displayName = "WH Wall: Door";
		model = "Bro_Modular_Warehouse\remaster\bro_mwhr_door.p3d";
		editorPreview = "Bro_Modular_Warehouse\remaster\thumbs\Land_Bro_MWHR_Door.jpg";
		numberOfDoors = 1;
		class AnimationSources {
			class Door_1 {
				source = "user";
				animPeriod = 0.8;
				initPhase = 0;
			};
			class Door_1_sound_source: Door_1 {
				Sound = "MetalDoorsSound";
				soundPosition="Door_1_trigger";
			};
			class Door_1_locked_source: Door_1{};
		};
		class UserActions {
			class OpenDoor_1 {
				displayNameDefault="<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\open_door_ca.paa' size='2' />";
				displayName="$STR_DN_OUT_O_DOOR";
				position="Door_1_trigger";
				actionNamedSel="Door_1";
				radius=2.0;
				onlyForPlayer=1;
				condition="((this animationSourcePhase 'Door_1_sound_source') < 0.5) && (cameraOn isKindOf 'CAManBase')";
				statement="([this, 1, 1] call BIS_fnc_Door)";
			};
			class CloseDoor_1: OpenDoor_1 {
				displayNameDefault="<img image='\A3\Ui_f\data\IGUI\Cfg\Actions\open_door_ca.paa' size='2' />";
				displayName="$STR_DN_OUT_C_DOOR";
				condition="((this animationSourcePhase 'Door_1_sound_source') >= 0.5) && ((this getVariable ['bis_disabled_Door_1', 0]) != 1) && (cameraOn isKindOf 'CAManBase')";
				statement="([this, 1, 0] call BIS_fnc_Door)";
			};
		};
	};
	class Land_Bro_MWHR_Garage: Land_Bro_MWHR_Plain {
		scope = 2;
		scopeCurator = 2;
		displayName = "WH Wall: Garage";
		model = "Bro_Modular_Warehouse\remaster\bro_mwhr_garage.p3d";
		editorPreview = "Bro_Modular_Warehouse\remaster\thumbs\Land_Bro_MWHR_Garage.jpg";
		numberOfDoors = 1;
		class AnimationSources {
			class Door_1 {
				source = "user";
				animPeriod = 5;
				initPhase = 0;
			};
			class Door_1_sound_source: Door_1 {
				Sound = "Bro_GarageSound";
				soundPosition="Door_1_axis";
			};
			class Door_1_locked_source: Door_1{
				animPeriod = 1;
			};
		};
		class UserActions {
			class OpenDoor_1 {
				displayNameDefault="<img image='\A3\ui_f\data\igui\cfg\actions\autohover_ca.paa' size='2' />";
				displayName="Open Garage";
				position="Door_1_trigger";
				actionNamedSel="Door_1";
				radius=2;
				onlyForPlayer=1;
				condition="((this animationSourcePhase 'Door_1_sound_source') < 0.5)";
				statement="([this, 1, 1] call BIS_fnc_Door)";
			};
			class CloseDoor_1: OpenDoor_1 {
				displayNameDefault="<img image='\A3\ui_f\data\igui\cfg\actions\autohover_ca.paa' size='2' />";
				displayName="Close Garage";
				condition="((this animationSourcePhase 'Door_1_sound_source') >= 0.5) && ((this getVariable ['bis_disabled_Door_1', 0]) != 1)";
				statement="([this, 1, 0] call BIS_fnc_Door)";
			};
		};
	};
	class Land_Bro_MWHR_Roof: Land_Bro_MWHR_Plain {
		scope = 2;
		scopeCurator = 2;
		displayName = "WH Ceiling";
		editorSubcategory = "Bro_MWHR_Roof";
		model = "Bro_Modular_Warehouse\remaster\bro_mwhr_roof.p3d";
		editorPreview = "a3\structures_f_exp\infrastructure\airports\data\airport_02_hangar_metal_03_co.paa";
	};
	class Land_Bro_MWHR_Floor: Land_Bro_MWHR_Plain {
		scope = 2;
		scopeCurator = 2;
		displayName = "WH Floor";
		editorSubcategory = "Bro_MWHR_Floor";
		model = "Bro_Modular_Warehouse\remaster\bro_mwhr_floor.p3d";
		editorPreview = "Bro_Modular_Warehouse\remaster\data\SmoothConc_co.paa";
	};
};