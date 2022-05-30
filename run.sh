./build.sh

echo "[LOG] Start test."

out/main.o < in/0002.txt > out/main.log

ahc011-tester in/0002.txt out/main.log

echo "[LOG] End test."

pbcopy < out/main.log
