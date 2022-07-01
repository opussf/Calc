#!/usr/bin/env swift
import Foundation

var stack: [Double] = []
var running: Bool = true

func getTwo() -> (var1: Double, var2: Double)? {
	guard let var1 = stack.popLast() else { return nil }
	guard let var2 = stack.popLast() else {
		stack.append(var1)
		return nil
	}
	return (var1, var2)
}
func sum() {
	guard let tup = getTwo() else { return }
	stack.append(tup.var1+tup.var2)
}
func sub() {
	guard let tup = getTwo() else { return }
	stack.append(tup.var2-tup.var1)
}
func mul() {
	guard let tup = getTwo() else { return }
	stack.append(tup.var2*tup.var1)
}
func divide() {
	guard let tup = getTwo() else { return }
	guard tup.var1 != 0 else {
		print("Connot divide by zero. Numbers pushed back on the stack.")
		stack.append(tup.var2)
		stack.append(tup.var1)
		return
	}
	stack.append(tup.var2 / tup.var1)
}
func percent() {
	guard let tup = getTwo() else { return }
	stack.append( tup.var2 )
	stack.append( tup.var2 )
	stack.append( tup.var1 )
	stack.append( 100 )
	divide()
	mul()
}
func power() {
	guard let tup = getTwo() else { return }
	stack.append( pow( tup.var2, tup.var1 ) )
}
func factorial() {
    guard let value = stack.popLast() else { return }
    if value < 0 {
        stack.append( Double.infinity )
    } else if value == 0 {
        stack.append( 1 )
    } else {
        var fac: Double = 1
        for lcv in 1...Int(value) {
            fac *= Double(lcv)
        }
        stack.append( fac )
    }
}
func swap() {
	guard let tup = getTwo() else { return }
	stack.append( tup.var1 )
	stack.append( tup.var2 )
}

let calcFunctions: [String: ()->Void] = [
	"+": sum,
	"-": sub,
	"*": mul,
	"/": divide,
	"%": percent,
	"^": power,
	"!": factorial,
	"pi": { () -> Void in stack.append( Double.pi ) },
	"π": { () -> Void in stack.append( Double.pi ) },
	"e": { () -> Void in stack.append( exp( 1 ) ) },
	"pop": { () -> Void in stack.removeLast() },
	"swap": swap,
	"ac": { () -> Void in stack = [] },
	"q": { () -> Void in running = false }
]

func in2End( _ txtIn: String ) -> [String] {
	var  result: [String] = []
	var opStack: [String] = []

	let operators: [Character: [Int] ] = [
		"+": [2, 1], "-": [2, 1],
		"*": [3, 1], "/": [3, 1],
		"^": [4, 2], "%": [4, 2], "!": [4, 2]
	]

	// print("txtIn: " + txtIn )
	var value: String = ""
	for char in txtIn {
		// print(char, terminator: "\t")
		// print(value, terminator: "\t")
		// print(result, terminator: "\t")
		// print(opStack)
		let currentOp = operators[char]
		if currentOp != nil {
			if value.count > 0 {
				result.append( value )
				value = ""
			}
			while( opStack.count > 0 ) {
				let lastOp = Character( opStack.last! )
				if opStack.last == "(" { break }
				else if ( ( currentOp![1] == 1 && currentOp![0] <= operators[lastOp]![0] ) ||
				          ( currentOp![1] == 2 && currentOp![0] <  operators[lastOp]![0] ) ) {
				        	result.append( opStack.popLast()! )
				        }
				else {
					break
				}
			}
			opStack.append( String(char) )
		} else if char == "(" {
			opStack.append( String(char) )
		} else if char == ")" {
			if value.count > 0 {
				result.append( value )
				value = ""
			}
			var opstackC: String? = opStack.last
			while( opstackC != nil && opstackC != "(" ) {
				result.append( opStack.popLast()! )
				opstackC = opStack.last
			}
			opStack.removeLast()
		} else if char == " " {
			if value.count > 0 {
				result.append( value )
				value = ""
			}
		} else {
			value = value + String( char )
		}
	}
	// print("result: ", terminator: "")
	// print( result )
	// print( opStack )
	return result
}

while running {
	print(stack.map{String($0)}.joined(separator: " ") + " >", terminator: "")

	guard let input: String = readLine(strippingNewline: true) else {
		running = false
		fatalError("Missing input")
	}

	var valsIn = ArraySlice(input.components(separatedBy: " "))
	var first = valsIn.popFirst()
	while first != nil {
		// print( first )
		if first != "" {
			let calcFunction = calcFunctions[first!]
			if calcFunction != nil {
				calcFunction!()
			} else if first!.prefix(1) == "(" && first!.suffix(1) == ")" {
				valsIn = in2End(first!) + valsIn
				print( valsIn )
			} else {
				stack.append( (first! as NSString).doubleValue )
			}
		}
		first = valsIn.popFirst()
	}

}

