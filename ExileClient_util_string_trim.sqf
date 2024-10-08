/**
 * ExileClient_util_string_trim
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
private _output = "";
isNil {

	private _input = _this;
	private _inputLetters = toArray _input; 
	private _inputLength = count _inputLetters;
	private _leftStartPosition = 0;
	private _rightEndPosition = _inputLength;
	private _whitespaceCharacters = [9, 10, 13, 32]; 
	for "_i" from 0 to _inputLength do
	{
		_letter = _inputLetters select _i;
		if !(_letter in _whitespaceCharacters) exitWith
		{
			_leftStartPosition = _i;
		};
	};
	for "_i" from _inputLength to 0 step -1 do
	{
		_letter = _inputLetters select _i;
		if !(_letter in _whitespaceCharacters) exitWith
		{
			_rightEndPosition = _i + 1;
		};
	};
	if (_leftStartPosition > 0 || _rightEndPosition < _inputLength) then
	{
		_output = toString (_inputLetters select [_leftStartPosition, _rightEndPosition - _leftStartPosition]);
	}
	else 
	{
		_output = _input;
	};
};
_output
