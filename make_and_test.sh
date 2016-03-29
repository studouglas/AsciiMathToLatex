#!/bin/bash
echo "Generating source code..."
lit -odir Literate_Output Main.lit Parser.lit Lexer.lit Util.lit ExpressionTypes.lit

echo "Compiling code..."
xcrun swiftc \
   -sdk $(xcrun --show-sdk-path --sdk macosx) \
   Literate_Output/main.swift \
   Literate_Output/parser.swift \
   Literate_Output/lexer.swift \
   Literate_Output/expressiontypes.swift \
   Literate_Output/util.swift \
   -o AsciiMathToLatex

echo "Testing code..."
echo 'a/b = c' | ./AsciiMathToLatex
echo
echo 'a+b <= c^4' | ./AsciiMathToLatex
echo
echo 'a/b -= alpha_(d in RR)^42 ~= qz sqrt5' | ./AsciiMathToLatex
echo
echo 'sum_(i=1)^n i^3=((n(n+1))/2)^2' | ./AsciiMathToLatex
echo