import subprocess
import sys


def test_run(exe_file):
    n = 100
    run = 5
    total_sum = 0
    for i in range(n):
        print(exe_file + ": " + str(i), file=sys.stderr)
        sum = 0
        in_file = "in/" + str(i).zfill(4) + ".txt"
        out_file = "out/" + str(i).zfill(4) + ".log"
        
        for j in range(run):
            with open(in_file) as f:
                _ = subprocess.run(
                    f"{exe_file} < {in_file} > {out_file}",
                    shell=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE
                )
                proc = subprocess.run(
                    ["ahc011-tester", in_file, out_file],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE
                )
                
                stdout = proc.stdout.decode("utf8")
                score = ""
                ok = False
                for c in stdout:
                    if c == "=":
                        ok = True
                    if c.isdigit() and ok:
                        score += c
                sum += int(score)
                total_sum += int(score)
        print("Average score for", in_file, sum / run)
        print("Average is", total_sum / (i+1) / run)
    print("[RESULT] Average is", total_sum / n / run, ":", exe_file)

test_run("out/main_60.o")
test_run("out/main_90.o")
test_run("out/main_120.o")
test_run("out/main_90_20.o")
