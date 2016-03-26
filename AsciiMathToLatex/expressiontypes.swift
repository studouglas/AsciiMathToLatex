protocol SimpleExpression {
	func toString() -> String
	func toLatexString() -> String
}
protocol Expression {
	func toString() -> String
	func toLatexString() -> String
}

struct ConstantSE: SimpleExpression {
	var str = ""
	init(str: String) {
		self.str = str
	}
	func toString() -> String {
		return str
	}
	func toLatexString() -> String {
		return latexForConstantSymbol(str)
	}
	private func latexForConstantSymbol(symbol: String) -> String {
		var latexSymbol = ""
		switch(symbol) {
		// operation symbols
		case "*": latexSymbol = "cdot"
		case "**": return "*"
		case "***": latexSymbol = "star"
		case "//": return "/"
		case "\\\\": return "\\ "
		case "xx": latexSymbol = "times"
		case "-:": latexSymbol = "div"
		case "@": latexSymbol = "circ"
		case "o+": latexSymbol = "oplus"
		case "ox": latexSymbol = "otimes"
		case "o.": latexSymbol = "odot"
		case "^^": latexSymbol = "land"
		case "^^^": latexSymbol = "bigwedge"
		case "vv": latexSymbol = "lor"
		case "vvv": latexSymbol = "bigvee"
		case "nn": latexSymbol = "intersection"
		case "nnn": latexSymbol = "bigcap"
		case "uu": latexSymbol = "union"
		case "uuu": latexSymbol = "bigcup"
		
		// miscellaneous symbols
		case "del": latexSymbol = "delta"
		case "grad": latexSymbol = "nabla"
		case "+-": latexSymbol = "pm"
		case "O/": latexSymbol = "Theta"
		case "oo": latexSymbol = "infty"
		case "/_": latexSymbol = "angle"
		case ":.": latexSymbol = "therefore"
		case "|cdots|": return "|\\cdots"
		case "|quad|": return "|\\quad|"
		case "diamond": latexSymbol = "Diamond"
		case "square": latexSymbol = ""
		case "|__": latexSymbol = "lfloor"
		case "__|": latexSymbol = "rfloor"
		case "|~": latexSymbol = "lceil"
		case "~|": latexSymbol = "rceil"
		case "CC": latexSymbol = "mathbb{C}"
		case "NN": latexSymbol = "mathbb{N}"
		case "QQ": latexSymbol = "mathbb{Q}"
		case "RR": latexSymbol = "mathbb{R}"
		case "ZZ": latexSymbol = "mathbb{Z}"
	
		// relation symbols
		case "!=": latexSymbol = "neq"
		case "<=": latexSymbol = "leq"
		case ">=": latexSymbol = "geq"
		case "-<": latexSymbol = "prec"
		case ">-": latexSymbol = "succ"
		case "!in": latexSymbol = "notin"
		case "sub": latexSymbol = "subset"
		case "sube": latexSymbol = "subseteq"
		case "sup": latexSymbol = "supset"
		case "supe": latexSymbol = "supseteq"
		case "-=": latexSymbol = "equiv"
		case "~=": latexSymbol = "cong"
		case "~~": latexSymbol = "approx"
		case "prop": latexSymbol = "propto"
	
		default: latexSymbol = symbol			
		}
		// single letters shouldn't have \ prepended
		if count(latexSymbol) == 1 || latexSymbol.toInt() != nil {
			return symbol
		}
		return "\\\(latexSymbol) "
	}

}

struct DelimitedSE: SimpleExpression {
	var expression: Expression!
	var bracketType: DelimiterType!
	
	init(expr: Expression, bracketType: DelimiterType) {
 		self.expression = expr
 		self.bracketType = bracketType
	}
	func toString() -> String {
		return "\(bracketType.leftString())\(expression.toString())\(bracketType.rightString())"
	}
	func toLatexString() -> String {
		var leftDelim = bracketType.leftString()
		var rightDelim = bracketType.rightString()
		if bracketType == .Brace {
			leftDelim = "\\{"
			rightDelim = "\\}"
		}
		return "\(leftDelim)\(expression.toLatexString())\(rightDelim)"
	}
}

struct UnarySE: SimpleExpression {
	var simpleExpression: SimpleExpression
	var unaryOperator = ""

	init(op: String, simpleExpr: SimpleExpression) {
		self.unaryOperator = op
		self.simpleExpression = simpleExpr
	}
	func toString() -> String {
		return "\(unaryOperator)\(simpleExpression.toString())"
	}
	func toLatexString() -> String {
		return "\\\(unaryOperator){\(simpleExpression.toLatexString())}"
	}
}

struct BinarySE: SimpleExpression {
	var simpleExpressionLeft: SimpleExpression
	var simpleExpressionRight: SimpleExpression
	var binaryOperator = ""

	init(op: String, leftSE: SimpleExpression, rightSE: SimpleExpression) {
		self.binaryOperator = op
		self.simpleExpressionLeft = leftSE
		self.simpleExpressionRight = rightSE
	}
	func toString() -> String {
		return "\(binaryOperator)\(simpleExpressionLeft.toString())\(simpleExpressionRight.toString())"
	}
	func toLatexString() -> String {
		return "\\\(binaryOperator){\(simpleExpressionLeft.toLatexString())}{\(simpleExpressionRight.toLatexString())}"
	}
}


struct SimpleExpressionE: Expression {
	var simpleExpression: SimpleExpression
	init(simpleExpr: SimpleExpression) {
		self.simpleExpression = simpleExpr
	}
	func toString() -> String {
		return simpleExpression.toString()
	}
	func toLatexString() -> String {
		return simpleExpression.toLatexString()
	}
}

struct SimpleSequenceE: Expression {
	var simpleExpression: SimpleExpression
	var expression: Expression

	init(simpleExpr: SimpleExpression, expr: Expression) {
		self.simpleExpression = simpleExpr
		self.expression = expr
	}
	func toString() -> String {
		return "\(simpleExpression.toString())\(expression.toString())"
	}
	func toLatexString() -> String {
		return "\(simpleExpression.toLatexString())\(expression.toLatexString())"
	}
}

struct SequenceE: Expression {
	var e1: Expression
	var e2: Expression
	init(e1: Expression, e2: Expression) {
		self.e1 = e1
		self.e2 = e2
	}
	func toString() -> String {
		return "\(e1.toString())\(e2.toString())"
	}
	func toLatexString() -> String {
		return "\(e1.toLatexString())\(e2.toLatexString())"
	}
}

struct FractionE: Expression {
	var simpleExpressionTop: SimpleExpression
	var simpleExpressionBottom: SimpleExpression

	init(top: SimpleExpression, bottom: SimpleExpression) {
		self.simpleExpressionTop = top
		self.simpleExpressionBottom = bottom
	}
	func toString() -> String {
		return "\(simpleExpressionTop.toString())/\(simpleExpressionBottom.toString())"
	}
	func toLatexString() -> String {
		return "\\frac{\(simpleExpressionTop.toLatexString())}{\(simpleExpressionBottom.toLatexString())}"
	}
}

struct SubscriptE: Expression {
	var simpleExpressionBase: SimpleExpression
	var simpleExpressionSubscript: SimpleExpression

	init(base: SimpleExpression, sub: SimpleExpression) {
		self.simpleExpressionBase = base
		self.simpleExpressionSubscript = sub
	}
	func toString() -> String {
		return "\(simpleExpressionBase.toString())_\(simpleExpressionSubscript.toString())"
	}
	func toLatexString() -> String {
		return "\(simpleExpressionBase.toLatexString())_{\(simpleExpressionSubscript.toLatexString())}"
	}
}

struct SuperscriptE: Expression {
	var simpleExpressionBase: SimpleExpression
	var simpleExpressionSuperscript: SimpleExpression

	init(base: SimpleExpression, superscript: SimpleExpression) {
		self.simpleExpressionBase = base
		self.simpleExpressionSuperscript = superscript
	}
	func toString() -> String {
		return "\(simpleExpressionBase.toString())^\(simpleExpressionSuperscript.toString())"
	}
	func toLatexString() -> String {
		return "\(simpleExpressionBase.toLatexString())^{\(simpleExpressionSuperscript.toLatexString())}"
	}
}

struct SubSuperscriptE: Expression {
	var simpleExpressionBase: SimpleExpression
	var simpleExpressionSubscript: SimpleExpression
	var simpleExpressionSuperscript: SimpleExpression

	init(base: SimpleExpression, sub: SimpleExpression, superscript: SimpleExpression) {
		self.simpleExpressionBase = base
		self.simpleExpressionSubscript = sub
		self.simpleExpressionSuperscript = superscript
	}
	func toString() -> String {
		return "\(simpleExpressionBase.toString())_\(simpleExpressionSubscript.toString())^\(simpleExpressionSuperscript.toString())"
	}
	func toLatexString() -> String {
		return "\(simpleExpressionBase.toLatexString())_{\(simpleExpressionSubscript.toLatexString())}^{\(simpleExpressionSuperscript.toLatexString())}"
	}
}


enum DelimiterType {
	case Paren, Bracket, Brace
	func leftString() -> String {
		switch self {
		case Paren: return "("
		case Bracket: return "["
		case Brace: return "{"
		}
	}
	func rightString() -> String {
		switch self {
		case Paren: return ")"
		case Bracket: return "]"
		case Brace: return "}"
		}
	}
	init(str: String) {
		switch(str) {
		case "(",")": self = Paren
		case "[","]": self = Bracket
		case "{","}": self = Brace
		default:
			println("Error. Trying to initialize DelimiterType with unsupported bracket '\(str)'")
			self = Paren
		}
	}
}


