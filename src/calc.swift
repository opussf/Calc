#!/usr/bin/env swift
import Foundation

var stack : [Float] = []
var running : Bool = true

func sum() {
	guard let var1 = stack.popLast() else { return }
	guard let var2 = stack.popLast() else {
		stack.append(var1)
		return
	}
	stack.append(var1+var2)
}
func sub() {
	guard let var1 = stack.popLast() else { return }
	guard let var2 = stack.popLast() else {
		stack.append(var1)
		return
	}
	stack.append(var2-var1)
}

let calcFunctions: [String: ()->Void] = [
	"+": sum,
	"-": sub,
	"q": { () -> Void in running = false }
]


while running {
	print(stack.map{String($0)}.joined(separator: " ") + ">")

	guard let input = readLine(strippingNewline: true) else {
		running = false
		fatalError("Missing input")
	}

	let calcFunction = calcFunctions[input]
	if calcFunction != nil {
		calcFunction!()
	} else {
		let valIn = (input as NSString).floatValue
		stack.append(valIn)
	}
}

