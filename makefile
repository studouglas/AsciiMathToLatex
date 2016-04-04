SDK_PATH = $(shell xcrun --show-sdk-path -sdk macosx)

all:
	lit -odir Literate_Output Literate_Source/*.lit
	xcrun swiftc -sdk $(SDK_PATH) Literate_Output/*.swift -o AsciiMathToLatex

clean:
	rm AsciiMathToLatex
	rm Literate_Output/*.swift
	rm Literate_Output/*.html
