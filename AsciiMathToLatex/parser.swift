class Parser {
	private let amEquation: String!
	private var lexer: Lexer!
	private var astRoot: Expression?

	init(amEquation: String) {
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
			var latexStr = astRoot!.toLatexString()
			latexStr = latexStr.stringByReplacingOccurrencesOfString("  ", withString: " ")
			latexStr = latexStr.stringByReplacingOccurrencesOfString("{(", withString: "{")
			latexStr = latexStr.stringByReplacingOccurrencesOfString(")}", withString: "}")
			latexStr = latexStr.stringByReplacingOccurrencesOfString(" }", withString: "}")
			latexStr = latexStr.stringByReplacingOccurrencesOfString(" _", withString: "_")
			latexStr = latexStr.stringByReplacingOccurrencesOfString(" ^", withString: "^")
			latexStr = latexStr.stringByReplacingOccurrencesOfString("(", withString: "\\left(")
			latexStr = latexStr.stringByReplacingOccurrencesOfString(")", withString: "\\right)")
			return latexStr
		} else {
			println("Error converting to LaTeX. AST is nil.")
			return ""
		}
	}

	private func getNextSimpleExpression() -> SimpleExpression? {
		var currentSymbolOpt = lexer.getNextSymbol()
		if currentSymbolOpt == nil {
			println("Error. Expected symbol in simple expression")
			return nil
		}
		if contains(expressionSymbols, currentSymbolOpt!) {
			currentSymbolOpt = lexer.getNextSymbol()
			if (currentSymbolOpt == nil) {
				println("Error. Expected symbol after expression operator")
				return nil
			}
		}
		let currentSymbol = currentSymbolOpt!
	
		if contains(leftDelimiters, currentSymbol) {
			if let nextExpression = getNextExpression() {
				let delimType = BracketType(str: currentSymbol)
				if let nextChar = lexer.peekNextCharacter() where String(nextChar) == delimType.rightString() {
					lexer.currentIndex++
					return DelimitedSE(expr: nextExpression, bracketType: delimType)
				} else {
					println("Error. '\(delimType.rightString())' expected after expression '\(nextExpression.toString())'")
					return nil
				} 
			} else {
				println("Error. expected expression after '\(currentSymbol)'")
				return nil
			}

		} else if contains(unarySymbols, currentSymbol) {
			if let nextSimpleExpression = getNextSimpleExpression() {
				return UnarySE(op: currentSymbol, simpleExpr: nextSimpleExpression)
			} else {
				println("Error. Simple expression expected after '\(currentSymbol)'")
				return nil
			}

		} else if contains(binarySymbols, currentSymbol) {
			if let nextSimpleExpression = getNextSimpleExpression(), 
				   finalSimpleExpression = getNextSimpleExpression() {
				return BinarySE(op: currentSymbol, leftSE: nextSimpleExpression, rightSE: finalSimpleExpression)
			} else {
				println("Error. Simple expression expected after '\(currentSymbol)'")
				return nil
			}

		} else {
			return ConstantSE(str: currentSymbol)
		}
	}

	private func getNextExpression() -> Expression? {
		let simpleExpressionOpt = getNextSimpleExpression()
		if (simpleExpressionOpt == nil) {
			return nil
		}
		let simpleExpression = simpleExpressionOpt!
		var currentExpression: Expression?
		var nextCharacter = lexer.peekNextCharacter()
	
		if nextCharacter == nil || contains(rightDelimiters, String(nextCharacter!)) {
			return SimpleExpressionE(simpleExpr: simpleExpression)
		}
		
		if !contains(expressionSymbols, String(nextCharacter!)) {
			if let nextExpression = getNextExpression() {
				return SequenceE(simpleExpr: simpleExpression, expr: nextExpression)
			} else {
				println("Error. Expression in SE case expected following '\(simpleExpression.toString())'")
				return nil
			}

		}
		
		if let nextSimpleExpression = getNextSimpleExpression() {
			switch (nextCharacter!) {		
			case "/":
				currentExpression = FractionE(top: simpleExpression, bottom: nextSimpleExpression)
	
			case "_":
				if (lexer.peekNextCharacter() == "^") {
					if let finalSimpleExpression = getNextSimpleExpression() {
						currentExpression = SubSuperscriptE(base: simpleExpression, sub: nextSimpleExpression, superscript: finalSimpleExpression)	
					} else {
						println("Error. Simple expression expected following '\(simpleExpression.toString())_\(nextSimpleExpression.toString())^'")
						return nil
					}

				} else {
					currentExpression = SubscriptE(base: simpleExpression, sub: nextSimpleExpression)
				}
	
			case "^":
				currentExpression = SuperscriptE(base: simpleExpression, superscript: nextSimpleExpression)
			
			default: break
			}
	
			if currentExpression != nil && lexer.currentIndex < count(amEquation) - 1
			&& !contains(rightDelimiters, String(lexer.peekNextCharacter()!)) {
				if let nextE = getNextExpression() {
					return SequenceExprE(e1: currentExpression!, e2: nextE)
				} else {
					println("Error. No expression found after '\(currentExpression)', but haven't reached end of equation.")
					return currentExpression
				}
			}

			
		}
		return currentExpression
	}


	
}

