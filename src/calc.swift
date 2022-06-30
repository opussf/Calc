#!/usr/bin/env swift
import Foundation

var stack : [Double] = []
var running : Bool = true

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
	"pi": { () -> Void in stack.append( Double.pi ) },
	"e": { () -> Void in stack.append( exp( 1 ) ) },
	"pop": { () -> Void in stack.removeLast() },
	"swap": swap,
	"ac": { () -> Void in stack = [] },
	"q": { () -> Void in running = false }
]

func in2End( _ txtIn: String ) {
	var result : [String] = []
	var opStack: [String] = []

	let operators: [Character: [Int] ] = [
		"+": [2,1], "-": [2,1]
	]

	print("txtIn: " + txtIn )
	var value: String = ""
	for c in txtIn {
		print(c)
		let op = operators[c]
		if op != nil {
			if value.count > 0 {
				result.append( value )
				value = ""
			}
			while( opStack.count > 0 ) {

			}
			opStack.append( String(c) )
		} else if c == "(" {
			opStack.append( String(c) )
		} else if c == ")" {
			if value.count > 0 {
				result.append( value )
				value = ""
			}
			var cc: Character? = c
			while( cc! != "(" ) {
				result.append( opStack.popLast()! )
				guard cc = opStack.last else { break }
			}
			opStack.removeLast()
		}



	}
	print("result: ", terminator: "")
	print( result )
	print( opStack )
}

while running {
	print(stack.map{String($0)}.joined(separator: " ") + " >", terminator: "")

	guard let input:String = readLine(strippingNewline: true) else {
		running = false
		fatalError("Missing input")
	}

	var valsIn = ArraySlice(input.components(separatedBy: " "))
	var first = valsIn.popFirst()
	while first != nil {
		//print( first )
		if first != "" {
			let calcFunction = calcFunctions[first!]
			if calcFunction != nil {
				calcFunction!()
			} else if first!.prefix(1) == "(" && first!.suffix(1) == ")" {
				in2End(first!)
			} else {
				stack.append( (first! as NSString).doubleValue )
			}
		}
		first = valsIn.popFirst()
	}

}

