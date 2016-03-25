import Foundation

class Parser {
	var errorMessage: String = ""
	var amEquation: String = ""

	init(amEquation: String) {
	    println("Parser initialized with: '\(amEquation)'")
	    self.amEquation = amEquation
	}

	func parseInput() -> Bool {
		let lexer = Lexer(amEquation: amEquation)
		var root: Expression? = lexer.getNextExpression()
		if let r = root {
			println("Done lexing, we now have our root expression!:\n")
			println(r.toString())
			println("\nAnd our LaTeX output:\n")
			println(r.toLatexString())
		} else {
			println("Root is nil")
		}
		return true
	}

	func convertToLatex() -> String {
		return ""
	}

}
enum BracketType {
	case Paren, Bracket, Brace
	func leftString() -> String {
		switch self {
			case Paren:
				return "("
			case Bracket:
				return "["
			case Brace:
				return "{"
		}
	}
	func rightString() -> String {
		switch self {
			case Paren:
				return ")"
			case Bracket:
				return "]"
			case Brace:
				return "}"
			
		}
	}
}

protocol SimpleExpression {
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
		return str
	}
}
struct DelimitedSE: SimpleExpression {
	var expression: Expression!
	var bracketType: BracketType!
	
	init(expr: Expression, bracketType: BracketType) {
 		self.expression = expr
 		self.bracketType = bracketType
	}
	func toString() -> String {
		return "\(bracketType.leftString())\(expression.toString())\(bracketType.rightString())"
	}
	func toLatexString() -> String {
		return "\(bracketType.leftString())\(expression.toLatexString())\(bracketType.rightString())"
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

protocol Expression {
	func toString() -> String
	func toLatexString() -> String
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
struct SequenceE: Expression {
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



