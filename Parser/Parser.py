# This file parses the ASP output to natural language.
#
# Usage: python Parser.py in_file.lp out_file.lp,
# where: in_file.lp must be valid ASP file.
import sys
import os
import re
from enum import Enum

class OutputArtery:
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
        text = "Artery with ID: [" + \
            str(self._id) + "] and Name: [" + self._name + "].\n"

        for confidence_rule in self._confidence_rules:
            text += str(confidence_rule)

        return text

class ArteryType(Enum):
    MainArtery = 0,
    BiforcationArtery = 1

class InputArtery:
    def __init__(self, artery_type, is_primary, name, id, heigth, angle, radius):
        self._arteryType = artery_type

        self._isPrimary = is_primary
        self._name = name

        self._id = id
        self._heigth = heigth
        self._angle = angle
        self._radius = radius

    def get_is_primary(self):
        return self._isPrimary

    def get_name(self):
        return self._name

    def get_id(self):
        return self._name

    def get_heigth(self):
        return self._heigth

    def get_angle(self):
        return self._angle

    def get_radius(self):
        return self._radius

    def __str__(self):
        text = self._name + " is a "

        if self._arteryType == ArteryType.MainArtery:
            text += "main artery."
        else:
            text += "biforcation artery."

        return text

class ConfidenceRule:
    def __init__(self, id, name):
        self._id = id
        self._name = name

        self._arteries = []
        self._rules = []

    def get_id(self):
        return self._id

    def get_name(self):
        return self._name

    def get_arteries(self):
        return self._arteries

    def get_rules(self):
        return self._rules

    def __str__(self):
        text = "\tConfidence Rule with ID: [" + \
            str(self._id) + "] and Name: [" + self._name + "].\n"

        for artery in self._arteries:
            text += "\t\tArtery rule: " + artery + "\n"

        for rule in self._rules:
            text += "\t\tRule: " + rule + "\n"

        return text

class GeneralRule:
    def __init__(self, artery, rule_text):
        self._artery = artery
        self._rule_text = rule_text

    def __str__(self):
        if self._artery != None:
            return self._artery.get_name() + " has " + self._rule_text
        else:
            return self._rule_text

class EdgeRule:
    def __init__(self, artery1, artery2):
        self._artery1 = artery
        self._artery2 = artery2
    
    def __str__(self):
        return self._artery1.get_name() + " is connected to " + self._artery2.get_name()

class HeightType(Enum):
    Greater = 0,
    Less = 1

class HeigthRule:
    def __init__(self, heigth_type, artery1, offset1, artery2, offset2):
        self._heigth_type = heigth_type

        self._artery1 = artery1
        self._offset1 = offset1

        self._artery2 = artery2
        self._offset2 = offset2
    
    def __str__(self):
        text = self._artery1.get_name() + "heigth" + self.offset1 + " is "

        if self._heigth_type == HeightType.Greater:
            text += "greater "
        else:
            text += "less "
        
        text += "than " + self._artery2.get_name() + "heigth" + self._offset2 + "."

general_dictionary = {
    "radius_small" : "Radius between 0 and 20 voxels.",
    "radius_big" : "Radius greater than 20 voxels.",

    "radius_s" : "Radius between 0 and 20 voxels.",
    "radius_m" : "Radius between 20 and 30 voxels.",
    "radius_l" : "Radius greater than 30 voxels.",

    "radius_1" : "Radius between 0 and 5 voxels.",
    "radius_2" : "Radius between 5 and 10 voxels.",
    "radius_3" : "Radius between 10 and 15 voxels.",
    "radius_4" : "Radius between 15 and 20 voxels.",
    "radius_5" : "Radius between 20 and 25 voxels.",
    "radius_6" : "Radius between 25 and 30 voxels.",
    "radius_7" : "Radius between 30 and 35 voxels.",
    "radius_8" : "Radius between 35 and 40 voxels.",
    "radius_9" : "Radius greater than 40 voxels.",


    "quadrant_1" : "Angle between 0 and 90 degrees.",
    "quadrant_2" : "Angle between 90 and 180 degrees.",
    "quadrant_3" : "Angle between 180 and 270 degrees.",
    "quadrant_4" : "Angle between 270 and 360 degrees." ,

    "shiftedquadrant_1" : "Angle between 330 and 360, or between 0 and 60 degrees.",
    "shiftedquadrant_2" : "Angle between 60 and 150 degrees.",
    "shiftedquadrant_3" : "Angle between 150 and 240 degrees.",
    "shiftedquadrant_4" : "Angle between 240 and 330 degrees.",

    "semiquadrant_1" : "Angle between 0 and 45 degrees.",
    "semiquadrant_2" : "Angle between 45 and 90 degrees.",
    "semiquadrant_3" : "Angle between 90 and 135 degrees.",
    "semiquadrant_4" : "Angle between 130 and 180 degrees.",
    "semiquadrant_5" : "Angle between 180 and 225 degrees.",
    "semiquadrant_6" : "Angle between 225 and 270 degrees.",
    "semiquadrant_7" : "Angle between 270 and 315 degrees.",
    "semiquadrant_8" : "Angle between 315 and 360 degrees."
}

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
        confidence_rule = ConfidenceRule(
            int(splitted_fact[2]), splitted_fact[1])

        artery = next(
            artery for artery in artery_list if artery.get_name() == splitted_fact[1])
        artery.get_confidence_rules().append(confidence_rule)

# Sort for artery.id
artery_list.sort(key=lambda artery: artery.get_id())

with open(sys.argv[2], "w") as out_file:
    for artery in artery_list:
        out_file.write(str(artery))

        if debug:
            print(artery, end=None)
