import sys
import os
import re

sys.argv.append("Tmp.txt")

print("Number of arguments:", len(sys.argv), "arguments.")
print("Argument List:", sys.argv)

if sys.argv.count == 1:
    print("no args")
    exit()

if not os.path.isfile(sys.argv[1]):
    print("no file")
    exit()

lines = []

with open(sys.argv[1], "r") as in_file:
    for line in in_file:
        lines.append(line.rstrip())

if lines.count == 0:
    print("file empty")
    exit()

print("File lines:", lines, "\n")

# -Create Fact regex
# -Create general Rule regex, ex: foo(a, _, 3).
#  -Create complete Rule regex, ex: foo(a, b, 3) :- bar(_,a,_), bar(3,_,_).
# -Find and split entries
# -Bidirectiona translation asp<->phrase

fact_regex = r"[a-z_]*\([a-z_]*\)\."
rule_regex = r"[a-z_]*\(([A-Z0-9_],?)*\)\ \:\-\ *"

for line in lines:
    if re.search(fact_regex, line) != None:
         print(" -Fact:", line)
    elif re.search(rule_regex, line) != None:
        print(" -Rule:", line)
    else:
        print("None:", line)
