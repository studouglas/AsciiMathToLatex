import Foundation

class Parser {
	var errorMessage: String = ""
	var amEquation: String = ""
	var astRoot: Expression?
	var lexer: Lexer!

	init(amEquation: String) {
	    println("Parser initialized with: '\(amEquation)'")
	    self.amEquation = amEquation
	    self.lexer = Lexer(amEquation: amEquation)
	}

	func parseInput() -> Bool {
		astRoot = getNextExpression()
		
		if astRoot != nil {
			return true
		} else {
			println("Error parsing input. AST is nil.")
			return false
		}
	}

	func convertToLatex() -> String {
		if astRoot != nil {
			return astRoot!.toLatexString()
		} else {
			println("Error converting to LaTeX. AST is nil.")
			return ""
		}
	}

	func getNextSimpleExpression() -> SimpleExpression? {
		// println("getNextSimpleExpression...")
		var currentSymbolOpt = lexer.getNextSymbol()
		if (currentSymbolOpt == nil) {
			println("Error. Expected symbol in getNextSimpleExpression")
			return nil
		}
		if (currentSymbolOpt! == "/" || currentSymbolOpt! == "_" || currentSymbolOpt! == "^") {
			currentSymbolOpt = lexer.getNextSymbol()
			if (currentSymbolOpt == nil) {
				println("Error. Expected non-nil symbol after /,_/^ in getNextSimpleExpression")
				return nil
			}
		}
		let currentSymbol = currentSymbolOpt!
		
		switch (String(currentSymbol)) {
			// lEr
			case "[":
				if let nextExpression = getNextExpression() {
					if let nextChar = lexer.peekNextCharacter() where String(nextChar) == "]" {
						return DelimitedSE(expr: nextExpression, bracketType: .Bracket)
					} else {
						println("Error. ']' expected after expression.")
						return nil
					} 
				} else {
					println("Error. expected expression after '\(currentSymbol)'")
					return nil
				}
			case "{":
				if let nextExpression = getNextExpression() {
					if let nextChar = lexer.peekNextCharacter() where String(nextChar) == "}" {
						return DelimitedSE(expr: nextExpression, bracketType:.Brace)
					} else {
						println("Error. '}' expected after expression.")
						return nil
					} 
				} else {
					println("Error. expected expression after '\(currentSymbol)'")
					return nil
				}
			case "(":
				if let nextExpression = getNextExpression() {
					if let nextChar = lexer.peekNextCharacter() where String(nextChar) == ")" {
						return DelimitedSE(expr: nextExpression, bracketType:.Paren)
					} else {
						println("Error. ')' expected after expression. nextExpression = '\(nextExpression.toString())'")
						return nil
					} 
				} else {
					println("Error. expected expression after '\(currentSymbol)'")
					return nil
				}
	
			// uS
			case "sqrt","text","bb":
				if let nextSimpleExpression = getNextSimpleExpression() {
					return UnarySE(op: currentSymbol, simpleExpr: nextSimpleExpression)
				} else {
					println("Error. simple expression expected after \(currentSymbol)")
					return nil
				}
			
			// bSS
			case "frac","root","stackrel":
				if let nextSimpleExpression = getNextSimpleExpression() {
					if let finalSimpleExpression = getNextSimpleExpression() {
						return BinarySE(op: currentSymbol, leftSE: nextSimpleExpression, rightSE: finalSimpleExpression)
					} else {
						println("Error. Simple expression expected after '\(currentSymbol)'")
						return nil	
					}
				} else {
					println("Error. Simple expression expected after '\(currentSymbol)'")
					return nil
				}
			// c
			default:
				return ConstantSE(str: currentSymbol)
		}
	}

	func getNextExpression() -> Expression? {
		let simpleExpressionOpt = getNextSimpleExpression()
		if (simpleExpressionOpt == nil) {
			println("Next simpleExpression nil in getNextExpression")
			return nil
		}
		let simpleExpression = simpleExpressionOpt!
		var currentExpression: Expression?
		let nextCharacter = lexer.peekNextCharacter()
		
		// S
		if (nextCharacter == nil || nextCharacter == ")") {
			return SimpleExpressionE(simpleExpr: simpleExpression)
		}
		
		// SE
		if nextCharacter != "/" && nextCharacter != "_" && nextCharacter != "^" {
			if let nextExpression = getNextExpression() {
				return SequenceE(simpleExpr: simpleExpression, expr: nextExpression)
			} else {
				println("Error. Expression in SE case expected following '\(simpleExpression.toString())'")
				return nil
			}
		}
		
		if let nextSimpleExpression = getNextSimpleExpression() {
			switch (nextCharacter!) {
			// S/S
			case "/":
				currentExpression = FractionE(top: simpleExpression, bottom: nextSimpleExpression)
	
			case "_":
				// S_S^S
				if (lexer.peekNextCharacter() == "^") {
					if let finalSimpleExpression = getNextSimpleExpression() {
						currentExpression = SubSuperscriptE(base: simpleExpression, sub: nextSimpleExpression, superscript: finalSimpleExpression)	
					} else {
						println("Error. Simple expression expected following '\(simpleExpression.toString())_\(nextSimpleExpression.toString())^'")
						return nil
					}
					
				} 
				// S_S
				else {
					currentExpression = SubscriptE(base: simpleExpression, sub: nextSimpleExpression)
				}
			
			// S^S
			case "^":
				currentExpression = SuperscriptE(base: simpleExpression, superscript: nextSimpleExpression)
			
			default: break
			}
		}
	
		if currentExpression != nil && lexer.currentIndex < count(amEquation) - 1 {
			if let nextE = getNextExpression() {
				return SequenceExprE(e1: currentExpression!, e2: nextE)
			} else {
				println("Error. No expression found after '\(currentExpression)', but haven't reached end of equation.")
				return currentExpression
				
			}
		}
		return currentExpression
	}


}

