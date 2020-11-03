import sys
import os
import re

class ConfidenceRule:
    def __init__(self, id, name):
        self._id = id
        self._name = name
    
    def get_id(self):
        return self._id
    
    def get_name(self):
        return self._name
    
    def __str__(self):
        return "\tConfidence Rule with ID: [" + str(self._id) + "] and Name: [" + self._name + "].\n"

class Artery:
    def __init__(self, id, name):
        self._id = id
        self._name = name
        self._confidence_rules = []

    def get_id(self):
        return self._id
    
    def get_name(self):
        return self._name
    
    def get_confidence_rules(self):
        return self._confidence_rules
    
    def __str__(self):
        message = "Artery with ID: [" + str(self._id) + "] and Name: [" + self._name + "].\n"  
        
        for confidence_rule in self._confidence_rules:
            message += str(confidence_rule)

        return (message + "\n")


os.chdir(os.path.dirname(__file__))

sys.argv.append("out1.lp")
sys.argv.append("parsed_out1.lp")

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

facts_content = ""

number_regex = re.compile(r"-?\d+")
splitted_file_content = file_content.split("Answer: ")

optimization_value = 0

for i in range(1, len(splitted_file_content)):
    splitted_results = splitted_file_content[i].splitlines()

    tmp_optimization_value = int(number_regex.search(splitted_results[2]).group(0))

    if tmp_optimization_value <= optimization_value:
        optimization_value = tmp_optimization_value
        facts_content = splitted_results[1]

artery_list = []

for fact_content in facts_content.split(' '):
    splitted_fact = fact_content.replace("(", ",").replace(")", "").split(",")

    if splitted_fact[0] == "artery":
        artery_list.append(Artery(int(splitted_fact[1]), splitted_fact[2]))
    else:
        artery = next(x for x in artery_list if x.get_name() == splitted_fact[1])

        artery.get_confidence_rules().append(ConfidenceRule(int(splitted_fact[2]), splitted_fact[1]))

artery_list.sort(key=lambda artery: artery.get_id())

with open(sys.argv[2], "w") as out_file:
    for artery in artery_list:
        out_file.write(str(artery))

        print(artery)