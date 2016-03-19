#!/bin/bash
echo "Generating source code..."
lit -odir AsciiMathToLatex AsciiMathToLatex.lit Parser.lit Lexer.lit Util.lit

echo "Compiling code..."
xcrun swiftc \
   -sdk $(xcrun --show-sdk-path --sdk macosx) \
   AsciiMathToLatex/main.swift \
   AsciiMathToLatex/parser.swift \
   AsciiMathToLatex/lexer.swift \
   AsciiMathToLatex/util.swift

echo "Testing code..."
echo 'a+b < c^4' | ./main
