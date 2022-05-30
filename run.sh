./build.sh

echo "[LOG] Start test."

out/main.o < in/0000.txt > out/main.log

ahc011-tester in/0000.txt out/main.log

echo "[LOG] End test."

pbcopy < out/main.log
