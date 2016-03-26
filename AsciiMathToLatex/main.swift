import Foundation

let stdin = NSFileHandle.fileHandleWithStandardInput()
let inputData = stdin.availableData;
let rawInputText = NSString(data: inputData, encoding: NSUTF8StringEncoding)
if (rawInputText == nil) {
    println("Usage: 'echo 'x + y' | ./main")
    exit(1)
}

let asciiMathText = rawInputText!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
println("AsciiMath Equation:")
println(asciiMathText)

let parser = Parser(amEquation: asciiMathText)
if !parser.parseInput() {
	println("Error parsing equation '\(asciiMathText)'. Exiting...")
	exit(2)
}


println("LaTeX Equation:")
println(parser.convertToLatex())


