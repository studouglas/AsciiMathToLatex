#!/bin/bash
echo "Generating source code..."
lit -odir AsciiMathToLatex AsciiMathToLatex.lit Parser.lit Lexer.lit Util.lit ExpressionTypes.lit

echo "Compiling code..."
xcrun swiftc \
   -sdk $(xcrun --show-sdk-path --sdk macosx) \
   AsciiMathToLatex/main.swift \
   AsciiMathToLatex/parser.swift \
   AsciiMathToLatex/lexer.swift \
   AsciiMathToLatex/expressiontypes.swift \
   AsciiMathToLatex/util.swift

echo "Testing code..."
echo 'a/b = c' | ./main
echo
echo 'a+b <= c^4' | ./main
echo
echo 'a/b -= alpha_(d in RR)^42 ~= qz sqrt5' | ./main
echo
echo 'sum_(i=1)^n i^3=((n(n+1))/2)^2' | ./main