/*
	bin_fnc_cargoPlatform_01_update

	Update cargo platform position
*/
params["_object"];
//systemChat str _this;
// If there is another cargo platform nearby then try to snap to it
// First we have to wait till dragging is completed
if ((is3DEN && {current3DENOperation != "" || {get3DENActionState "MoveGridToggle" == 0}})) exitWith {};

private _nearbyObjects = nearestObjects [_object, ["Bro_MWH_Base"], 13];
_nearbyObjects = _nearbyObjects - [_object];
//systemChat str _nearbyObjects;
if (_nearbyObjects isEqualTo []) exitWith {};

private _nearestObject	= _nearbyObjects # 0;
private _pos			= getposASL _object;


// Those are recognized as valid points only when side of platform is hidden
private _snapPoint			= [];
private _snapPointsParent	= [];
for "_i" from 1 to 4 do
{
	_snapPointsParent pushBack (_object modelToWorldVisual (_object selectionPosition format["snap_%1",_i]));
};

if (_snapPointsParent isEqualTo []) exitWith {};

for "_i" from 1 to 4 do
{
	_snapPoint = _nearestObject modelToWorldVisual (_nearestObject selectionPosition format["snap_%1",_i]);
	{
		// Continue if snap points are found
		if (_snapPoint distance _x <= 1) exitWith
		{
			// Reconvert to model space due to dir change
			_posModel = _object worldToModel _x;

			// Adjust direction
			_dirTo		= getDir _nearestObject - 360;
			_dirObject	= getDir _object;
			_dir		= _dirTo;

			for "_i" from 0 to 7 do
			{
				_dir = _dirTo + _i * 90;
				if(abs(_dir - _dirObject) < 45)then
				{
					_i = 10;
				};
			};
			_object set3DENAttribute ["rotation",[0,0, _dir]];

			// Recalc position in case direction was changed
			_x = _object modelToWorldVisual _posModel;

			// Transform position
			_pos = _pos vectorDiff (_x vectorDiff _snapPoint);
			_pos = [_pos # 0, _pos # 1, (getposASL (_nearbyObjects # 0)) # 2];
			//systemChat format["pos found %1",_pos];

			// Snap to position
			_object set3DENAttribute ["position",ASLToATL _pos];

			// Exit "for" loop
			_i = 10;
		};
	} forEach _snapPointsParent;
};

//systemChat format["nearby objects %1 %2 snap point %3",_nearestObject,_object distance _nearestObject,_snapPointsParent];
