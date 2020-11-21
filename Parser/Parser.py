# This file parses the ASP output to natural language.
#
# Usage: python Parser.py in_file.lp out_file.lp,
# where: in_file.lp must be valid ASP file.
import sys
import os
import re
from enum import Enum

class ConfidenceRule:
    def __init__(self, id: int, name: str):
        self._id = id
        self._name = name

        self._arteries = []
        self._rules = []

    def get_id(self) -> int:
        return self._id

    def get_name(self) -> str:
        return self._name

    def get_arteries(self) -> list:
        return self._arteries

    def get_rules(self) -> list:
        return self._rules

    def __str__(self) -> str:
        text = "\tConfidence Rule with ID: [" + \
            str(self._id) + "] and Name: [" + self._name + "].\n"

        for artery in self._arteries:
            text += "\t\tArtery rule: " + str(artery) + "\n"

        for rule in self._rules:
            text += "\t\tRule: " + str(rule) + "\n"

        return (text + "\n")

class ArteryType(Enum):
    MainArtery = 0,
    BiforcationArtery = 1

class InputArtery:
    def __init__(self, artery_type: ArteryType, is_primary: bool, name: str, id: str, heigth: str, angle: str, radius: str):
        self._arteryType = artery_type

        self._is_primary = is_primary
        self._name = name

        self._id = id
        self._heigth = heigth
        self._angle = angle
        self._radius = radius

    def get_is_primary(self) -> bool:
        return self._is_primary

    def get_name(self) -> str:
        return self._name

    def get_id(self) -> str:
        return self._id

    def get_heigth(self) -> str:
        return self._heigth

    def get_angle(self) -> str:
        return self._angle

    def get_radius(self) -> str:
        return self._radius

    def __str__(self) -> str:
        text = self._name + " is a "

        if self._arteryType == ArteryType.MainArtery:
            text += "main artery."
        else:
            text += "biforcation artery."

        return text

class EdgeRule:
    def __init__(self, artery1: InputArtery, artery2: InputArtery):
        self._artery1 = artery1
        self._artery2 = artery2
    
    def __str__(self) -> str:
        return self._artery1.get_name() + " is connected to " + self._artery2.get_name()

class HeigthType(Enum):
    Greater = 0,
    Less = 1

class HeigthRule:
    def __init__(self, heigth_type: HeigthType, artery1: InputArtery, offset1: str, artery2: InputArtery, offset2: str):
        self._heigth_type = heigth_type

        self._artery1 = artery1
        self._offset1 = offset1

        self._artery2 = artery2
        self._offset2 = offset2
    
    def __str__(self) -> str:
        text = self._artery1.get_name() + " heigth" + self._offset1 + " is "

        if self._heigth_type == HeigthType.Greater:
            text += "greater "
        else:
            text += "less "
        
        text += "than " + self._artery2.get_name() + " heigth" + self._offset2 + "."

        return text

class GeneralRule:
    def __init__(self, artery: InputArtery, rule_text: str):
        self._artery = artery
        self._rule_text = rule_text

    def __str__(self) -> str:
        if self._artery != None:
            return self._artery.get_name() + " has " + self._rule_text
        else:
            return self._rule_text

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

class OutputArtery:
    def __init__(self, id: int, name: str):
        self._id = id
        self._name = name
        self._confidence_rules = []

    def get_id(self) -> int:
        return self._id

    def get_name(self) -> str:
        return self._name

    def get_confidence_rules(self) -> list:
        return self._confidence_rules

    def __str__(self) -> str:
        text = "Artery with ID: [" + str(self._id) + "] and Name: [" + self._name + "].\n"

        for confidence_rule in self._confidence_rules:
            text += str(confidence_rule)

        return (text + "\n")

def main():
    # To simplify debug
    debug = True

    if debug:
        os.chdir(os.path.dirname(__file__))

        sys.argv.append("arteries_classifier.lp")
        sys.argv.append("out1.lp")
        sys.argv.append("parsed_out1.lp")
    elif (len(sys.argv) < 3) or (not os.path.isfile(sys.argv[1])) or (not os.path.isfile(sys.argv[2])):
        print("Usage: python Parser.py in_file1.lp in_file2.lp out_file.lp")
        exit()

    # To find integers number
    number_regex = re.compile(r"-?\d+")
    another_regex = re.compile(r"[+-]\d+")

    confidence_rules = []

    with open(sys.argv[1], "r") as in_file:
        file_content_lines = in_file.readlines()

    for file_content_line in file_content_lines:
        if file_content_line.startswith("confidence_rule"):
            rules = file_content_line.replace("\n", "").split(", ")

            name = rules[0].split("= ")
            id = number_regex.search(name[0]).group(0)

            confidence_rule = ConfidenceRule(id, name[1])
        
            for i in range(1, len(rules)):
                rule = rules[i].replace("(", ",").replace(")", ",").split(",")

                if rule[0] == "main_artery":
                    id = rule[1] if rule[1] != "_" else None
                    heigth = rule[2] if rule[2] != "_" else None
                    angle = rule[3] if rule[3] != "_" else None 
                    radius = rule[4] if rule[4] != "_" else None

                    is_primary = rule[5] != "_"
                    name = rule[5] if rule[5] != "N" else confidence_rule.get_name()

                    artery = InputArtery(ArteryType.MainArtery, is_primary, name, id, heigth, angle, radius)
                    confidence_rule.get_arteries().append(artery)
                elif rule[0] == "bif_artery":
                    id = rule[1] if rule[1] != "_" else None
                    radius = rule[2] if rule[2] != "_" else None

                    is_primary = rule[3] != "_"
                    name = rule[3] if rule[3] != "N" else confidence_rule.get_name()

                    artery = InputArtery(ArteryType.BiforcationArtery, is_primary, name, id, None, None, radius)
                    confidence_rule.get_arteries().append(artery)
                elif rule[0] == "edge":
                    artery1 = next((artery for artery in confidence_rule.get_arteries() if artery.get_id() == rule[1]), None)
                    artery2 = next(artery for artery in confidence_rule.get_arteries() if artery.get_id() == rule[2])

                    if artery1 == None:
                        artery1 = InputArtery(ArteryType.MainArtery, False, rule[1], None, None, None, None)
                        confidence_rule.get_arteries().append(artery1)
                
                    edge_rule = EdgeRule(artery1, artery2)
                    confidence_rule.get_rules().append(edge_rule)
                elif rule[0] == "height_greater" or rule[0] == "height_less":
                    heigth_type = HeigthType.Greater if rule[0] == "height_greater" else HeigthType.Less

                    offset_regex1 = another_regex.search(rule[1])
                    offset_regex2 = another_regex.search(rule[2])

                    offset1 = offset_regex1.group(0) if offset_regex1 != None else ""
                    offset2 = offset_regex2.group(0) if offset_regex2 != None else ""

                    heigth1 = rule[1][0 : offset_regex1.start()] if offset_regex1 != None else rule[1]
                    heigth2 = rule[1][0 : offset_regex2.start()] if offset_regex2 != None else rule[2]

                    artery1 = next(artery for artery in confidence_rule.get_arteries() if artery.get_heigth() == heigth1)
                    artery2 = next(artery for artery in confidence_rule.get_arteries() if artery.get_heigth() == heigth2)

                    heigth_rule = HeigthRule(heigth_type, artery1, offset1, artery2, offset2)
                    confidence_rule.get_rules().append(heigth_rule)
                else:
                    rule_text = general_dictionary.get(rule[0], None)

                    if rule_text != None:
                        artery = next(artery for artery in confidence_rule.get_arteries() if artery.get_is_primary)

                        general_rule = GeneralRule(artery, rule_text)
                        confidence_rule.get_rules().append(general_rule)
                    else:
                        rules[0] = confidence_rule.get_name() + " has: "
                        rule_text = " ".join(rules)

                        general_rule = GeneralRule(None, rule_text)
                        confidence_rule.get_rules().append(general_rule)

                        break

            confidence_rules.append(confidence_rule)    
            
    with open(sys.argv[2], "r") as in_file:
        file_content = in_file.read()

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

    arteries = []

    # Can be: artery(id, name) or confidence_rule(name, id)
    for fact_content in facts_content.split(' '):
        splitted_fact = fact_content.replace("(", ",").replace(")", "").split(",")

        if splitted_fact[0] == "artery":
            artery = OutputArtery(int(splitted_fact[1]), splitted_fact[2])

            arteries.append(artery)
        else:
            artery = next(artery for artery in arteries if artery.get_name() == splitted_fact[1])
            confidence_rule = next(confidence_rule for confidence_rule in confidence_rules if confidence_rule.get_id() == splitted_fact[2] and confidence_rule.get_name() == splitted_fact[1])

            artery.get_confidence_rules().append(confidence_rule)

    # Sort for artery.id
    arteries.sort(key=lambda artery: artery.get_id())

    with open(sys.argv[3], "w") as out_file:
        for artery in arteries:
            out_file.write(str(artery))

            if debug:
                print(artery, end=None)

if __name__ == "__main__":
    main()