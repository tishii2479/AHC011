echo "[LOG] Combinate files..."

python3 comb.py

echo "[LOG] Output file: out/main.swift"
echo "[LOG] Compile out/main.swift..."

swiftc out/main.swift -o out/main.o

echo "[LOG] Compile done. -> tools/out/main"
