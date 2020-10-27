import sys
import os
import re
from collections import OrderedDict

sys.argv.append("out2.lp")

print("Number of arguments:", len(sys.argv), "arguments.")
print("Argument List:", sys.argv)

if sys.argv.count == 1:
    print("no args")
    exit()

if not os.path.isfile(sys.argv[1]):
    print("no file")
    exit()

with open(sys.argv[1], "r") as in_file:
    file_content = in_file.read()

# print(file_content)
rgx1 = r"Answer: -?\d+"
rgx2 = r"Optimization: -?\d+"
rgx3 = r"-?\d+"

value1=0
value2=""

while True:
    start_regex = re.search(rgx1, file_content)

    if not start_regex:
        break

    start_regex=start_regex.group(0)
    start_index = file_content.index(start_regex) + len(start_regex)

    end_regex = re.search(rgx2, file_content).group(0)
    end_index = file_content.index(end_regex)

    value_regex = int(re.search(rgx3, end_regex).group(0))

    if int(value_regex) <= value1:
        value1=value_regex
        value2=file_content[start_index:end_index]
    
    file_content = file_content[end_index+len(end_regex)+1:]

print(value1, value2)

values = value2.replace("\n", "").split(") ")
print(values)

dictionary={}

for value in values:
    info = value.split(",")

    id = int(re.search(rgx3, info[0]).group(0))
    name = info[1] 
    
    dictionary[id] = name

dictionary = OrderedDict(sorted(dictionary.items()))

for entry in dictionary:
    print("Found artery name:", dictionary[entry],"with id:", entry)