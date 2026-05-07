/*
	fn_snap.sqf

	Snap a modular object to nearby compatible objects via Memory LOD snap points.
	Named selections expected in Memory LOD: snap_1 through snap_4 (gaps allowed).

	Parameters:
		0: OBJECT - the object being moved/placed
*/
params [["_object", objNull]];

// Skip during active 3DEN drag operations
if (is3DEN && {current3DENOperation != "" || {get3DENActionState "MoveGridToggle" == 0}}) exitWith {};

// Skip when multiple objects are selected to prevent group moves destroying layouts
if (count (get3DENSelected "Object") > 1) exitWith {};

private _nearbyObjects = nearestObjects [_object, ["Bro_MWH_Base"], 13] - [_object];
if (_nearbyObjects isEqualTo []) exitWith {};

// Collect this object's snap point world positions
// selectionPosition returns [0,0,0] for missing selections - filter those out
private _mySnapPoints = [];
for "_i" from 1 to 4 do {
	private _selPos = _object selectionPosition format ["snap_%1", _i];
	if !(_selPos isEqualTo [0,0,0]) then {
		_mySnapPoints pushBack (_object modelToWorldVisual _selPos);
	};
};
if (_mySnapPoints isEqualTo []) exitWith {};

// Search all nearby objects for the closest matching snap point pair
private _bestDist = 1.0;
private _bestMyPoint = [];
private _bestTheirPoint = [];
private _bestObject = objNull;

{
	private _other = _x;
	for "_i" from 1 to 4 do {
		private _theirSelPos = _other selectionPosition format ["snap_%1", _i];
		if !(_theirSelPos isEqualTo [0,0,0]) then {
			private _theirWorldPos = _other modelToWorldVisual _theirSelPos;
			{
				private _dist = _x distance _theirWorldPos;
				if (_dist < _bestDist) then {
					_bestDist = _dist;
					_bestMyPoint = _x;
					_bestTheirPoint = _theirWorldPos;
					_bestObject = _other;
				};
			} forEach _mySnapPoints;
		};
	};
} forEach _nearbyObjects;

if (isNull _bestObject) exitWith {};

// Find the closest 90-degree rotation increment relative to the target object
// Uses modular arithmetic to correctly handle the 0/360 degree boundary
private _dirTarget = getDir _bestObject;
private _dirCurrent = getDir _object;
private _bestDir = _dirTarget;
private _bestDiff = 360;
for "_j" from 0 to 3 do {
	private _candidate = _dirTarget + _j * 90;
	private _diff = abs (((_candidate - _dirCurrent + 540) mod 360) - 180);
	if (_diff < _bestDiff) then {
		_bestDiff = _diff;
		_bestDir = _candidate;
	};
};

// Save snap point in model space before rotation is applied
// After set3DENAttribute the world transform changes, so model space is stable
private _snapPosModel = _object worldToModel _bestMyPoint;

_object set3DENAttribute ["rotation", [0, 0, _bestDir]];

// Recalculate where that model-space point now sits in world space post-rotation
private _snapPosWorld = _object modelToWorldVisual _snapPosModel;

// Shift the object so our snap point coincides with theirs
private _newPosASL = (getPosASL _object) vectorAdd (_bestTheirPoint vectorDiff _snapPosWorld);

// Lock Z to the target object's altitude for flush/level placement
_newPosASL set [2, (getPosASL _bestObject) # 2];

_object set3DENAttribute ["position", ASLToATL _newPosASL];
