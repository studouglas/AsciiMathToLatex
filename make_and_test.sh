#!/bin/bash
echo "Generating source code..."
lit -odir AsciiMathToLatex AsciiMathToLatex.lit Parser.lit

echo "Compiling code..."
xcrun swiftc \
   -sdk $(xcrun --show-sdk-path --sdk macosx) AsciiMathToLatex/main.swift AsciiMathToLatex/parser.swift

echo "Testing code..."
echo 'a+b < c^4' | ./main
