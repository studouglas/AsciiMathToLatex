#!/usr/bin/env xcrun swift
import Foundation

let error = "Error"
let cases = [("a/b = c","\\frac{a}{b} = c"),
			 ("a+b <= c^4","a+b \\leq c^{4}"),
			 ("a/b -= alpha_(d in RR)^42 ~= qz sqrt5","\\frac{a}{b} \\equiv \\alpha_{d \\in \\mathbb{R}}^{42} \\cong qz \\sqrt{5}"),
			 ("sum_(i=1)^n i^3=((n(n+1))/2)^2","\\sum_{i=1}^{n} i^{3}=\\left(\\frac{n\\left(n+1\\right)}{2}\\right)^{2}"),
			 ("a+(c", error),
			 ("b+(c + d/b", error)]
let executablePath = "./AsciiMathToLatex"

// http://stackoverflow.com/a/26972043/1176865
func shell(launchPath: String, arguments: [AnyObject]) -> String {
    let task = NSTask()
    task.launchPath = launchPath
    task.arguments = arguments

    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let rawOutput = NSString(data: data, encoding: NSUTF8StringEncoding)!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    let output = rawOutput as String

    return output
}

var testsPassed = 0
for i in 0..<cases.count {
	
	let input = cases[i].0
	let desiredOutput = cases[i].1
	var result = shell(executablePath, [input])
	
	// if expecting an error, pass if result starts with 'Error'
	if desiredOutput == error && result.hasPrefix("Error") {
		result = error
	}

	if result == desiredOutput {
		println("Test \(i+1) passed\n\tInput '\(input)'\n\tOutput '\(result)'")
		testsPassed++
	} else {
		println("Test \(i+1) failed\n\tInput '\(input)'\n\tOutput '\(result)'\n\tExpected '\(desiredOutput)'")
	}
}

println("\n\(testsPassed) out of \(cases.count) tests passed.\n")

