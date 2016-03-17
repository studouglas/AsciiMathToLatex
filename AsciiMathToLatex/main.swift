import Foundation

println("Processing input...")
let stdin = NSFileHandle.fileHandleWithStandardInput()
let inputData = stdin.availableData;
let rawInputText = NSString(data: inputData, encoding: NSUTF8StringEncoding)
if (rawInputText == nil) {
    println("Usage: 'echo 'x + y' | ./main")
    exit(1)
}

let asciiMathText = rawInputText!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
println("AsciiMath Equation: '\(asciiMathText)'")

let parser = Parser(amEquation: asciiMathText)
if !parser.parseInput() {
	println(parser.errorMessage)
	exit(2)
}
println("Parsed input successfully!")

let latexOutput = parser.convertToLatex()
println("LaTeX output:")
println(latexOutput)



