#!/usr/bin/env swift
import Foundation

var stack : [Double] = []
var running : Bool = true

func gettwo() -> (var1: Double, var2: Double)? {
	guard let var1 = stack.popLast() else { return nil }
	guard let var2 = stack.popLast() else {
		stack.append(var1)
		return nil
	}
	return (var1, var2)
}
func sum() {
	guard let tup = gettwo() else { return }
	stack.append(tup.var1+tup.var2)
}
func sub() {
	guard let tup = gettwo() else { return }
	stack.append(tup.var2-tup.var1)
}
func mul() {
	guard let tup = gettwo() else { return }
	stack.append(tup.var2*tup.var1)
}
func divide() {
	guard let tup = gettwo() else { return }
	guard tup.var1 != 0 else {
		print("Connot divide by zero. Numbers pushed back on the stack.")
		stack.append(tup.var2)
		stack.append(tup.var1)
		return
	}
	stack.append(tup.var2 / tup.var1)
}
func percent() {
	guard let tup = gettwo() else { return }
	stack.append( tup.var2 )
	stack.append( tup.var2 )
	stack.append( tup.var1 )
	stack.append( 100 )
	divide()
	mul()
}
func power() {
	guard let tup = gettwo() else { return }
	stack.append( pow( tup.var2, tup.var1 ) )
}
func swap() {
	guard let tup = gettwo() else { return }
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
	"pop": { () -> Void in stack.removeLast() },
	"swap": swap,
	"ac": { () -> Void in stack = [] },
	"q": { () -> Void in running = false }
]


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
			} else {
				stack.append( (first! as NSString).doubleValue )
			}
		}
		first = valsIn.popFirst()
	}

}

