class Lexer {
	private let amEquation: String!
	private let allSymbols: [String]!
	var currentIndex: Int = 0

	init(amEquation: String) {
		self.amEquation = amEquation
	
		allSymbols = [unarySymbols, binarySymbols, leftDelimiters, rightDelimiters, expressionSymbols,
					  greekSymbols, relationSymbols, operationSymbols, miscSymbols].flatMap { $0 }
	}

	func getNextSymbol() -> String? {
		let currentCharacter = getNextCharacter()
		if (currentCharacter == nil) {
			return nil
		}
	
		var currentSymbol = String(currentCharacter!)
	
		// currentChar is first character of multicharacter symbol
		if let multicharSymbol = getMulticharSymbol() {
			return multicharSymbol
		} else {
			// multiple digit numbers are one symbol
			if currentSymbol.toInt() != nil {
				var nextChar = peekNextCharacter()
				while (nextChar != nil && String(nextChar!).toInt() != nil) {
					currentSymbol += String(nextChar!)
					currentIndex++
					nextChar = peekNextCharacter()
				}
			}
			return currentSymbol
		}
	}
	
	private func getMulticharSymbol() -> String? {
		var longestMatch = ""
		for symbol in allSymbols {
			let symLength = count(symbol)
			if currentIndex + symLength <= count(amEquation)
			&& amEquation[currentIndex-1..<currentIndex+symLength-1] == symbol
			&& symLength > count(longestMatch) {
				longestMatch = amEquation[currentIndex-1..<currentIndex+symLength-1]
			}
		}
	
		if longestMatch != "" {
			currentIndex += count(longestMatch) - 1
			return longestMatch
		}
		return nil
	}
	
	func peekNextCharacter() -> Character? {
		if (currentIndex >= count(amEquation)) {
			return nil
		}
		return amEquation[currentIndex]
	}

	func getNextCharacter() -> Character? {
		if (currentIndex >= count(amEquation)) {
			return nil
		} else {
			let c: Character? = amEquation[currentIndex];
			currentIndex++;
			return c
		}
	}

}
let unarySymbols = ["sqrt", "text", "bb","hat","bar","ul","vec","dot","ddot"]
let binarySymbols = ["frac", "root", "stackrel"]
let leftDelimiters = ["(", "[", "{"]
let rightDelimiters = [")", "]", "}"]
let expressionSymbols = ["^", "_", "/"]

// constants
let greekSymbols = ["alpha","beta","chi","delta","Delta","epsilon","varepsilon",
				    "eta","gamma","Gamma","iota","kappa","lambda","Lambda","mu",
				    "nu","omega","Omega","phi","Phi","varphi","pi","Pi","psi",
				    "Psi","rho","sigma","Sigma","tau","theta","Theta","vartheta",
				    "upsilon","xi","Xi","zeta"]
let relationSymbols = ["!=","<=",">=","-<",">-","in","!in","sub","sup","sube","supe",
				   	   "-=","~=","~~","prop"]
let operationSymbols = ["**","***","//","\\\\","xx","-:","@","o+","ox","o.","sum",
						"prod","^^","^^^","vv","vvv","nn","nnn","uu","uuu"]
let miscSymbols = ["int","oint","del","grad","+-","O/","oo","aleph","/_",":.","|...|",
				   "|cdots|","vdots","ddots","|\\|","|quad|","diamond","square","|__",
				   "__|","|~","~|","CC","NN","QQ","RR","ZZ"]
let logicalSymbols = ["and","or","not","=>","if","iff","AA","EE","_|_","TT","|--","|=="]
let arrowSymbols = ["uarr","darr","rarr","->","|->","larr","harr","rArr","lArr","hArr"]


