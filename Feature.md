# Feature.md

## tempFunctions
Add `toC` and `toF` functions.

## ceil / floor / round functions
- perform a celing or floor operation on the value on the stack
- round to the nearest integer.
	- >= x.5 rounds up to x+1
	- < x.5 rounds down to x
	- use math.modf( x ) which returns "integral fractional" of x

## Macros
Add the ability to define and use macros.

Make this command line.
'/calc macro AHmountInGold 5000000 token / ceil 20 *'
^^^ assigns the function to AHmountInGold

'/calc macro AHmountInGold'
^^^ shows the macro

'/calc macro del AHmountInGold'
^^^ deletes the macro

'/calc macro list'
^^^ lists all the macros



