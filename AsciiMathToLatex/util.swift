extension String {
	subscript(i: Int) -> Character {
		return Array(self)[i]	
	}
	subscript(r: Range<Int>) -> String {
		return String(Array(self)[r.startIndex ..< r.endIndex])
	}

}

