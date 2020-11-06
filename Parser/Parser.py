# This file parses the ASP output to natural language.
#
# Usage: python Parser.py in_file.lp out_file.lp,
# where: in_file.lp must be valid ASP file.
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
        message = "Artery with ID: [" + \
            str(self._id) + "] and Name: [" + self._name + "].\n"

        for confidence_rule in self._confidence_rules:
            message += str(confidence_rule)

        return (message + "\n")


# To simplify debug
debug = True

if debug:
    os.chdir(os.path.dirname(__file__))

    sys.argv.append("out1.lp")
    sys.argv.append("parsed_out1.lp")
elif (len(sys.argv) < 3) or (not os.path.isfile(sys.argv[1])) or (not os.path.isfile(sys.argv[2])):
    print("Usage: python Parser.py in_file.lp out_file.lp")
    exit()

with open(sys.argv[1], "r") as in_file:
    file_content = in_file.read()

# To find integers number
number_regex = re.compile(r"-?\d+")

# Support variable to find best entry
facts_content = ""
optimization_value = 0

splitted_file_content = file_content.split("Answer: ")

# Skip [0] because of ASP verbose info
for i in range(1, len(splitted_file_content)):
    # [0] = answer number (skip), [1] = facts, [2] = optimizazion_value
    splitted_results = splitted_file_content[i].splitlines()

    tmp_optimization_value = number_regex.search(splitted_results[2]).group(0)
    tmp_optimization_value = int(tmp_optimization_value)

    # Lower is best
    if tmp_optimization_value <= optimization_value:
        optimization_value = tmp_optimization_value
        facts_content = splitted_results[1]

artery_list = []

# Can be: artery(id, name) or confidence_rule(name, id)
for fact_content in facts_content.split(' '):
    splitted_fact = fact_content.replace("(", ",").replace(")", "").split(",")

    if splitted_fact[0] == "artery":
        artery = Artery(int(splitted_fact[1]), splitted_fact[2])

        artery_list.append(artery)
    else:
        confidence_rule = ConfidenceRule(int(splitted_fact[2]), splitted_fact[1])

        artery = next(artery for artery in artery_list if artery.get_name() == splitted_fact[1])
        artery.get_confidence_rules().append(confidence_rule)

# Sort for artery.id
artery_list.sort(key=lambda artery: artery.get_id())

with open(sys.argv[2], "w") as out_file:
    for artery in artery_list:
        out_file.write(str(artery))

        if debug:
            print(artery, end=None)