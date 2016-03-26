class Lexer {
	let amEquation: String!
	var currentIndex: Int = 0
	
	let allSymbols: [String]!

	init(amEquation: String) {
		self.amEquation = amEquation
	
		let unarySymbols = ["sqrt", "text", "bb","hat","bar","ul","vec","dot","ddot"]
		let binarySymbols = ["frac", "root", "stackrel"]
		let leftDelimeters = ["(", "[", "{"]
		let rightDelimeters = [")", "]", "}"]
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
	
		allSymbols = [unarySymbols, binarySymbols, leftDelimeters, rightDelimeters, expressionSymbols,
					  greekSymbols, relationSymbols, operationSymbols, miscSymbols].flatMap { $0 }
	}

	func getNextSymbol() -> String? {
		let currentCharacter = getNextCharacter()
	
		if (currentCharacter == nil) {
			// println("ERROR. Current character is nil in getNextSymbol().")
			return nil
		}
	
		var currentSymbol: String? = String(currentCharacter!)
	
		// currentChar is first character of multicharacter symbol
		if let multicharSymbol = getMulticharSymbol() {
			return multicharSymbol
		} else {
			return String(currentCharacter!)
		}
	}
	
	func getMulticharSymbol() -> String? {
		var longestMatch = ""
		for symbol in allSymbols {
			let symLength = count(symbol)
			if currentIndex + symLength < count(amEquation)
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
			println("currentIndex = \(currentIndex) in equation '\(amEquation)'")
			return nil
		} else {
			let c: Character? = amEquation[currentIndex];
			currentIndex++;
			return c
		}
	}

}



