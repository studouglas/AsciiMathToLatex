import Foundation

class Parser {
	var errorMessage: String = ""
	var amEquation: String = ""

	init(amEquation: String) {
	    println("Parser initialized with: '\(amEquation)'")
	    self.amEquation = amEquation
	}

	func parseInput() -> Bool {
		let lexer = Lexer(amEquation: amEquation);
		while (lexer.currentCharacter != nil) {
			lexer.getSymbol()
			// println(lexer.currentCharacter)
		}
		return true
	}

	func convertToLatex() -> String {
		return ""
	}

}

