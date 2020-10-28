import sys
import os
import re
from collections import OrderedDict

os.chdir(os.path.dirname(__file__))

sys.argv.append("out2.lp")
sys.argv.append("parsed_out2.lp")

print("Number of arguments:", len(sys.argv), "arguments.")
print("Arguments List:", sys.argv, "\n")

if sys.argv.count == 1:
    print("No args. Exiting...")
    exit()

if not os.path.isfile(sys.argv[1]):
    print("No file. Exiting...")
    exit()

with open(sys.argv[1], "r") as in_file:
    file_content = in_file.read()

answer_regex = r"Answer: -?\d+"
optimization_regex = r"Optimization: -?\d+"
number_regex = r"-?\d+"

optimization_value = 0
content=""

while True:
    start_regex = re.search(answer_regex, file_content)

    if not start_regex:
        break

    start_regex = start_regex.group(0)
    start_index = file_content.index(start_regex) + len(start_regex)

    end_regex = re.search(optimization_regex, file_content).group(0)
    end_index = file_content.index(end_regex)

    tmp_optimization_value = int(re.search(number_regex, end_regex).group(0))

    if tmp_optimization_value <= optimization_value:
        optimization_value = tmp_optimization_value
        content = file_content[start_index : end_index]
    
    file_content = file_content[end_index + len(end_regex) + 1 :]

print("Optimization value:", optimization_value)

content_values = content.replace("\n", "").split(") ")
print("Content values:", content_values, "\n")

dictionary = {}

for content_value in content_values:
    values = content_value.split(",")

    id = int(re.search(number_regex, values[0]).group(0))
    name = values[1] 
    
    dictionary[id] = name

dictionary = OrderedDict(sorted(dictionary.items()))

with open(sys.argv[2], "w") as out_file:
    for entry in dictionary:
        output = "Found artery with id: " + str(entry) + " and name: " + dictionary[entry] + "."
        print(output)

        out_file.write(output + "\n")