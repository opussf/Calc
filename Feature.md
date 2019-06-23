# Feature.md

## infix
Since this is an addon for wow at its core, there is no commandline prompt to clue the user what mode ( rpn / infix ) they are in.
This is also complicated with the fact that this is originally an RPN calculator.

There are 3 ways that I can think of currently to handle this:

* Have a setting, put the calculator into RPN or inFix mode.
	- Pro: keeps this simple
	- Pro: lets the user determine which they want
	- Pro: the user is probably an RPN or inFix user, and probably not switching between the 2 much.
	- Con: no prompt to show the state, may be confusing to the user. Probably not a concern.
* Have a function that parses an inFix line.
	- Pro: nothing for the user to remember, except the command
	- Con: user has to use this everytime  `infix 5 + 2`
	- Con: using the == for chat makes this 'awkward'
	- Quesiton: how does this handle mixing modes?  `5 infix + 2`
* Try to determine the difference per command.
	- Pro: nothing for the user to remember
	- Pro:

Questions:
* How does this handle the stack nature of the calculator?
* How handle `5<enter>` `+<enter>` `5<enter`
	- Build a string, converting to RPN each time. Only complete if a value can be returned from the string.
	`5 +` is not a valid inFix

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

'/calc macro pi 22 7 /'
^^^ should create an error, since pi is a function already

'/calc AHmountInGold'
^^^ loads the macro and runs the calculation


