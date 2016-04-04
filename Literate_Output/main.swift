import Foundation

if Process.argc != 2 {
	println("Usage: ./AsciiMathToLatex 'AsciiMath Equation Here'\n(note the single quotation marks)")
	exit(1)
} 
let rawInputText = String.fromCString(Process.unsafeArgv[1])
let asciiMathText = rawInputText!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

let parser = Parser(amEquation: asciiMathText)
if !parser.parseInput() {
	println("Error parsing equation '\(asciiMathText)'. Exiting...")
	exit(2)
}

println(parser.convertToLatex())


