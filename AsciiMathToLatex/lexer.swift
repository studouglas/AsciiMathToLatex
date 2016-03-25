class Lexer {
	let amEquation: String!
	var currentIndex: Int = 0
	
	let SQRT = "sqrt"
	let TEXT = "text"
	let BB = "bb"
	
	let FRAC = "frac"
	let ROOT = "root"
	let STACKREL = "stackrel"
	
	let LPAREN = "("
	let RPAREN = ")"
	let LBRACKET = "["
	let RBRACKET = "]"
	let LBRACE = "{"
	let RBRACE = "}"
	// todo, add smiley face bracket things
	
	let SUPERSCRIPT = "^"
	let SUBSCRIPT = "_"
	
	let DIV = "/"
	let EOF = ""
	let SPACE = " "
	
	let unarySymbols: [String]!
	let binarySymbols: [String]!
	let leftDelimeters: [String]!
	let rightDelimeters: [String]!
	let expressionSymbols: [String]!


	init(amEquation: String) {
		self.amEquation = amEquation
	
		unarySymbols = [SQRT, TEXT, BB]
		binarySymbols = [FRAC, ROOT, STACKREL]
		leftDelimeters = [LPAREN, LBRACKET, LBRACE]
		rightDelimeters = [RPAREN, RBRACKET, RBRACE]
		expressionSymbols = [SUPERSCRIPT, SUBSCRIPT, DIV]
	}

	func getNextSymbol() -> String? {
		let currentCharacter = getNextCharacter()
	
		if (currentCharacter == nil) {
			println("ERROR. Current character is nil in getNextSymbol().")
			return nil
		}
	
		var currentSymbol: String? = String(currentCharacter!)
		println("Lexer about to getSymbol for character: '\(currentCharacter!)'")
		switch currentCharacter! {
			case "b":
				if amEquation[currentIndex] == "b" {
					currentSymbol = BB
					currentIndex++
				}
			case "f":
				if amEquation[currentIndex ..< currentIndex+count(FRAC)] == FRAC[1 ..< count(FRAC)] {
					currentSymbol = FRAC
					currentIndex += count(FRAC) - 1
				}
			case "r":
				if amEquation[currentIndex ..< currentIndex+count(ROOT)] == ROOT[1 ..< count(ROOT)]	{
					currentSymbol = ROOT
					currentIndex += count(ROOT) - 1
				}
			case "s":
				if amEquation[currentIndex ..< currentIndex+count(SQRT)] == SQRT[1 ..< count(SQRT)] {
					currentSymbol = SQRT
					currentIndex += count(SQRT) - 1
				} else if amEquation[currentIndex ..< currentIndex + count(STACKREL)] == STACKREL[1 ..< count(STACKREL)] {
					currentSymbol = STACKREL
					currentIndex += count(STACKREL) - 1
				}
			case "t":
				if amEquation[currentIndex ..< currentIndex+count(TEXT)] == TEXT[1 ..< count(TEXT)] {
					currentSymbol = TEXT
					currentIndex += count(TEXT) - 1
				}
	
			// brackets
			case "(":
				currentSymbol = LPAREN
			case ")":
				currentSymbol = RPAREN
			case "[":
				currentSymbol = LBRACKET
			case "]":
				currentSymbol = RBRACKET
			case "{":
				currentSymbol = LBRACE
			case "}":
				currentSymbol = RBRACE
			
			// single-symbol operators
			case "^":
				currentSymbol = SUPERSCRIPT
			case "_":
				currentSymbol = SUBSCRIPT
			case "/":
				currentSymbol = DIV
	
			default:
				currentSymbol = String(currentCharacter!)
		}
		println("Lexer set currentSymbol to: '\(currentSymbol)'")
		return currentSymbol
	}
	
	func peekNextCharacter() -> Character? {
		if (currentIndex >= count(amEquation)) {
			return nil
		}
		return amEquation[currentIndex]
	}

	func getNextCharacter() -> Character? {
		if (currentIndex >= count(amEquation)) {
			println("Lexer reached end of amEquation")
			return nil
		} else {
			let c: Character? = amEquation[currentIndex];
			currentIndex++;
			println("Lexer got currentCharacter: '\(c)', currentIndex: \(currentIndex)")
			return c
		}
	}

	func getNextSimpleExpression() -> SimpleExpression? {
		println("getNextSimpleExpression")
		var currentSymbolOpt = getNextSymbol()
		if (currentSymbolOpt == nil) {
			println("Error. Expected symbol in getNextSimpleExpression")
			return nil
		}
		if (currentSymbolOpt! == "/" || currentSymbolOpt! == "_" || currentSymbolOpt! == "^") {
			currentSymbolOpt = getNextSymbol()
			if (currentSymbolOpt == nil) {
				println("Error. Expected non-nil symbol after /,_/^ in getNextSimpleExpression")
				return nil
			}
		}
		let currentSymbol = currentSymbolOpt!
		
		switch (String(currentSymbol)) {
			// lEr
			case LBRACKET:
				if let nextExpression = getNextExpression() {
					if let nextChar = peekNextCharacter() where String(nextChar) == RBRACKET {
						return DelimitedSE(expr: nextExpression, bracketType: .Bracket)
					} else {
						println("Error. '\(RBRACKET)' expected after expression.")
						return nil
					} 
				} else {
					println("Error. expected expression after '\(currentSymbol)'")
					return nil
				}
			case LBRACE:
				if let nextExpression = getNextExpression() {
					if let nextChar = peekNextCharacter() where String(nextChar) == RBRACE {
						return DelimitedSE(expr: nextExpression, bracketType:.Brace)
					} else {
						println("Error. '\(RBRACE)' expected after expression.")
						return nil
					} 
				} else {
					println("Error. expected expression after '\(currentSymbol)'")
					return nil
				}
			case LPAREN:
				if let nextExpression = getNextExpression() {
					if let nextChar = peekNextCharacter() where String(nextChar) == RPAREN {
						return DelimitedSE(expr: nextExpression, bracketType:.Paren)
					} else {
						println("Error. '\(RPAREN)' expected after expression.")
						return nil
					} 
				} else {
					println("Error. expected expression after '\(currentSymbol)'")
					return nil
				}
	
			// uS
			case SQRT,TEXT,BB:
				if let nextSimpleExpression = getNextSimpleExpression() {
					return UnarySE(op: currentSymbol, simpleExpr: nextSimpleExpression)
				} else {
					println("Error. simple expression expected after \(currentSymbol)")
					return nil
				}
			
			// bSS
			case FRAC,ROOT,STACKREL:
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
		println("GetNextExpression...")
		let simpleExpressionOpt = getNextSimpleExpression()
		if (simpleExpressionOpt == nil) {
			println("Next simpleExpression nil in getNextExpression")
			return nil
		}
		let simpleExpression = simpleExpressionOpt!
	
		// verify currentSymbol is a SimpleExpression
		let nextCharacter = peekNextCharacter()
		
		// S
		if (nextCharacter == nil) {
			return SimpleExpressionE(simpleExpr: simpleExpression)
		}
		
		// SE
		if nextCharacter != "/" && nextCharacter != "_" && nextCharacter != "^" {
			if let nextExpression = getNextExpression() {
				return SequenceE(simpleExpr: simpleExpression, expr: nextExpression)
			} else {
				println("Error. Expression expected following '\(simpleExpression.toString())'")
				return nil
			}
		}
	
		if let nextSimpleExpression = getNextSimpleExpression() {
			switch (nextCharacter!) {
			// S/S
			case "/":
				return FractionE(top: simpleExpression, bottom: nextSimpleExpression)
	
			case "_":
				// S_S^S
				if (peekNextCharacter() == "^") {
					if let finalSimpleExpression = getNextSimpleExpression() {
						return SubSuperscriptE(base: simpleExpression, sub: nextSimpleExpression, superscript: finalSimpleExpression)	
					} else {
						println("Error. Simple expression expected following '\(simpleExpression.toString())_\(nextSimpleExpression.toString())^'")
						return nil
					}
					
				} 
				// S_S
				else {
					return SubscriptE(base: simpleExpression, sub: nextSimpleExpression)
				}
			
			// S^S
			case "^":
				return SuperscriptE(base: simpleExpression, superscript: nextSimpleExpression)
			
			default:
				break
			}
		} else {
			println("Error. Simple expresssion expected following '\(simpleExpression.toString())\(nextCharacter)'")
		}
		return nil
	}

}

