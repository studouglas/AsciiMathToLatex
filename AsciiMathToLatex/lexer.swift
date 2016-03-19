class Lexer {
	let amEquation: String!
	var keywords: [Keyword] = [Keyword]()
	
	var currentSymbol: String?
	var currentCharacter: Character?
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


	enum KeywordType {
		case Unary
		case Binary
	}

	struct Keyword {
		var id = ""
		var type: KeywordType!
		init(id: String, type: KeywordType) {
			self.id = id
			self.type = type
		}
	}

	init(amEquation: String) {
		println("Lexer initializing...")
		keywords.append(Keyword(id: SQRT, type: .Unary))
		keywords.append(Keyword(id: TEXT, type: .Unary))
		keywords.append(Keyword(id: BB, type: .Unary))
		
		keywords.append(Keyword(id: FRAC, type: .Binary))
		keywords.append(Keyword(id: ROOT, type: .Binary))
		keywords.append(Keyword(id: STACKREL, type: .Binary))
		
		keywords.append(Keyword(id: SUBSCRIPT, type: .Binary))
		keywords.append(Keyword(id: SUPERSCRIPT, type: .Binary))

		self.amEquation = amEquation
		// note: swift 2.2 supports accessing chracter array directly,
		// but i'm using older compiler so must manually make the array
		// self.amEquationChars.reserveCapacity(count(amEquation)) // for performance
		// for c in amEquation {
		// 	self.amEquationChars.append(c)
		// }
		getCharacter()
		getSymbol()
	}

	func getSymbol() {
		if (currentCharacter == nil) {
			println("ERROR. Current character is nil.")
			currentSymbol = EOF
			return
		}
	
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
	
			// space
			case " ":
				currentSymbol = SPACE
			default:
				currentSymbol = nil
		}
		println("Lexer set currentSymbol to: '\(currentSymbol)'")
		getCharacter()
	}

	func getCharacter() {
		if (currentIndex >= count(amEquation)) {
			println("Lexer reached end of amEquation")
			currentCharacter = nil;
		} else {
			currentCharacter = amEquation[currentIndex];
			currentIndex++;
			println("Lexer got currentCharacter: '\(currentCharacter)', currentIndex: \(currentIndex)")
		}
	}

}

