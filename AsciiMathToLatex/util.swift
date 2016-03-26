extension String {
	subscript(i: Int) -> Character {
		return Array(self)[i]	
	}
	subscript(i: Int) -> String {
		return String(Array(self)[i])
	}
	subscript(r: Range<Int>) -> String {
		return String(Array(self)[r.startIndex ..< r.endIndex])
	}

}


