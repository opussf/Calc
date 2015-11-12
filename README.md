# Calc
A RPN calculator for WoW

# RPN (postfix)
In short, RPN is a way of writing calculations without the need of brackets.
Values are entered, and then the operands are given to work with the previous 1 or 2 values.
In the simple case of `1 + 2`, a user would enter `1 2 +`, and the result would be the remaining value.

RPN uses the idea of a stack, where values are pushed on and operands pop off the last 1 or 2 values and push on the result.
In the example above `1 2 +` pushes 1 and 2 onto the stack, `+` then pops off `1` and `2`, adds them together and pushes `3` back to the stack.

Conversion of complicated equations is much simplier that one might expect.
In case the reader does not wish to research this on their own, I'll give a quick example.
To convert a Farhrenheit temperature to Celsius, one would use the equation: `(F - 32) / (9/5)`.
Converting the normal human body temperature of 98.6F is simply `98.6 32 - 9 5 / /`.
Working from left to right, this calculates `98.6 - 32` resulting in `66.6`, then `9 / 5` gives `1.8`.
The RPN *stack* would now look like `66.6 1.8` and with the final division, would produce the result of `37`.

Conversion from Celsius to Farhrenheit would be `C * 9/5 + 32`.
Converting 37 would give us `37 9 5 / * 32 +`, though other ways could be constucted to do the same calculation.
`9/5 * C + 32` could be written as `9 5 / 37 * 32 +`.

Feel free to search the web on how to use this amazingly simple notation.

## Commands
This uses `/calc <data>` to accept input.
If `<data>` is a value, or a known constant, or predefined variable, that value is pushed to the stack.
`/calc pi` would push the value of `pi` to the stack.
After each command, the values on the stack will be displayed.

### Constants
The constants currently supported are:
* pi - uses *Lua's* `math.pi` constant
* e - uses *Lua's* `math.exp(1)` to get `e`

### Operands
The operands currently supported are:
* `+` - biparameter addition
* `-` - biparameter subtraction `5 7 -` yields `5 - 7`
* `*` - biparameter addition
* `/` - biparameter division `9 5 /` yields `9 / 5`
* `^` - biparameter power `3 3 ^` yields `3^3`
* `ln` - monoparameter natural log `e ln` yields 1
* 'sin' - monoparameter `sine` in radians
* 'cos' - monoparameter `cosine` in radians
* 'tan' - monoparameter `tangent` in radians

### Commands
The current commands supported are:
* `AC` - All Clear - clear the entire stack
* `deg` - sets trig functions to use degrees
* `rad` - sets trig functions to use radians

### Entering data
HP is notorius for using, or forcing the use of, **ENTER** to seperate values as they were entered on their calculators.
This can be simulated here with using a seperate `/calc` for each value, though that can get old and annoying in a hurry.
To streamline this a bit, the entire set of commands can be entered as a single space seperated line following `/calc`.

    /calc 3
    /calc 2
    /calc +
Would be the same as `/calc 3 2 +`.
