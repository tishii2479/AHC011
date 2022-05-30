echo "[LOG] Combinate files..."

python3 comb.py

echo "[LOG] Output file: out/main.swift"
echo "[LOG] Compile out/main.swift..."

swiftc out/main.swift -o out/main.o

#echo "[LOG] Compile main.cpp..."

#g++ -std=c++17 main.cpp -o out/main.o

echo "[LOG] Compile done. -> out/main.o"
