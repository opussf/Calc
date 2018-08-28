# Feature.md

## tempFunctions
Add `toC` and `toF` functions.

## ceil / floor / round functions
- perform a celing or floor operation on the value on the stack
- round to the nearest integer.
	- >= x.5 rounds up to x+1
	- < x.5 rounds down to x
	- use math.modf( x ) which returns "integral fractional" of x


