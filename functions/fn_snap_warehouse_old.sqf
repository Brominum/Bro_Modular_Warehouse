/*
	fn_snap_warehouse_old.sqf
	Snap a modular warehouse wall or roof (Bro_MWH_Base) to a near compatible object with the snap points of its model.
	Named selections: snap_1 to snap_8 (gaps are permitted). Each snap selection must contain only one vertex.
	Parameters:
		0: OBJECT - the object that the user moved or placed
*/
params [["_object", objNull]];
if (isNull _object) exitWith {};
// Do not snap while an Eden operation is active or when grid snap is off
if (is3DEN && {current3DENOperation != "" || {get3DENActionState "MoveGridToggle" == 0}}) exitWith {};
// Do not snap when more than one object is selected. This prevents damage to the layout during a group move.
if (count (get3DENSelected "Object") > 1) exitWith {};
// Maximum horizontal distance between two snap points that can connect
private _tolXY = 1.0;
// Maximum vertical distance between two snap points that can connect
// Keep this value less than the height of one wall (10 m). Roofs connect to walls only through the extra snap points on the wall tops.
private _tolZ = 1.0;
// Search radius: from the object center to its farthest snap point (roof piece corner: 7.1 m), plus the same for the other object, plus the tolerance
private _nearbyObjects = (nearestObjects [_object, ["Bro_MWH_Base"], 16]) - [_object];
if (_nearbyObjects isEqualTo []) exitWith {};
// Get the snap points of an object in model space
// selectionPosition gives [0,0,0] for a selection that does not exist
private _fnc_snapPoints = {
	private _points = [];
	for "_i" from 1 to 8 do {
		private _pos = _this selectionPosition format ["snap_%1", _i];
		if !(_pos isEqualTo [0,0,0]) then {
			_points pushBack _pos;
		};
	};
	// Extra snap points from config: {selection, x, y, z}. Each point is the selection position plus the offset (model space, z is up).
	// The walls get points on their top edge and the roof pieces get points where they sit on a wall, so that a roof can snap to the walls below it.
	{
		_x params ["_sel", "_dx", "_dy", "_dz"];
		private _pos = _this selectionPosition _sel;
		if !(_pos isEqualTo [0,0,0]) then {
			_points pushBack (_pos vectorAdd [_dx, _dy, _dz]);
		};
	} forEach getArray (configOf _this >> "bro_mwh_extraSnaps");
	_points
};
// Turn a model space vector around the Z axis into world space for a given direction (degrees, clockwise from north)
private _fnc_rotate = {
	params ["_v", "_dir"];
	_v params ["_vx", "_vy", "_vz"];
	[_vx * cos _dir + _vy * sin _dir, _vy * cos _dir - _vx * sin _dir, _vz]
};
private _myPoints = _object call _fnc_snapPoints;
if (_myPoints isEqualTo []) exitWith {};
// Find the nearest pair of snap points in world space (ASL)
// A pair is a candidate only if it is in the horizontal and vertical limits
private _bestDist = 1e10;
private _bestMyModel = [];
private _bestTheirWorld = [];
private _bestObject = objNull;
{
	private _other = _x;
	{
		private _theirWorld = _other modelToWorldWorld _x;
		{
			private _myWorld = _object modelToWorldWorld _x;
			private _dist = _myWorld distance _theirWorld;
			if (_myWorld distance2D _theirWorld < _tolXY && {abs ((_myWorld # 2) - (_theirWorld # 2)) < _tolZ} && {_dist < _bestDist}) then {
				_bestDist = _dist;
				_bestMyModel = _x;
				_bestTheirWorld = _theirWorld;
				_bestObject = _other;
			};
		} forEach _myPoints;
	} forEach (_other call _fnc_snapPoints);
} forEach _nearbyObjects;
if (isNull _bestObject) exitWith {};
// Find the 90 degree step of the target direction that is nearest to the current direction
// The modulo operation correctly handles the 0/360 degree boundary
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
// Calculate the new position from the model data. Do not read the position again after the rotation changes.
// The model origin must be at the target snap point minus our snap point turned to the new direction
private _newPosWorld = _bestTheirWorld vectorDiff ([_bestMyModel, _bestDir] call _fnc_rotate);
// getPosASL is not the model origin. Keep its offset from the origin in model space, then turn it to the new direction.
private _aslOffset = [(getPosASL _object) vectorDiff (getPosWorld _object), -_dirCurrent] call _fnc_rotate;
private _newPosASL = _newPosWorld vectorAdd ([_aslOffset, _bestDir] call _fnc_rotate);
_object set3DENAttribute ["rotation", [0, 0, _bestDir % 360]];
_object set3DENAttribute ["position", ASLToATL _newPosASL];
