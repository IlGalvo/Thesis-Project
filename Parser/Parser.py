# This file parses the ASP output to natural language.
#
# Usage: python Parser.py in_arteries_classifier.lp in_arteries_classified.lpout_arteries_parsed.txt
# where: in_arteries_classifier.lp and in_arteries_classified.lp must be valid ASP file.

import sys
import os
import re
from enum import Enum


# InputArtery can be main or biforcation
class ArteryType(Enum):
    Main = 0,
    Biforcation = 1


# InputArtery has type,
# is primary if it refers to confidence rule,
# has a name
# and id, heigth, angle and radius are optional
class InputArtery:
    def __init__(self, artery_type: ArteryType,
                 is_primary: bool, name: str,
                 id: str = None, heigth: str = None, angle: str = None, radius: str = None):
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

        text += "main" if self._arteryType == ArteryType.Main else "biforcation"

        return text + " artery."


# Common rule interface
class IRule:
    def to_text(self) -> str:
        pass


# Edge rule referes to two arteries IDs
class Edge(IRule):
    def __init__(self, artery1: InputArtery, artery2: InputArtery):
        self._artery1 = artery1
        self._artery2 = artery2

    def to_text(self) -> str:
        return self.__str__()

    def __str__(self) -> str:
        return self._artery1.get_name() + " is connected to " + self._artery2.get_name() + "."


# Heigth rule can be greater or less
class HeigthType(Enum):
    Greater = 0,
    Less = 1


# Heigth rule referes to two arteries Z and their offsets
class Heigth(IRule):
    def __init__(self, heigth_type: HeigthType,
                 artery1: InputArtery, offset1: str,
                 artery2: InputArtery, offset2: str):
        self._heigth_type = heigth_type

        self._artery1 = artery1
        self._offset1 = offset1

        self._artery2 = artery2
        self._offset2 = offset2

    def to_text(self) -> str:
        return self.__str__()

    def __str__(self) -> str:
        text = self._artery1.get_name() + " heigth" + self._offset1 + " is "

        text += "greater" if self._heigth_type == HeigthType.Greater else "less"

        return text + " than " + self._artery2.get_name() + " heigth" + self._offset2 + "."


# General rule has a text description and can refer to an artery
class General(IRule):
    def __init__(self, rule_text: str, artery: InputArtery = None):
        self._rule_text = rule_text
        self._artery = artery

    def to_text(self) -> str:
        return self.__str__()

    def __str__(self) -> str:
        if self._artery != None:
            return self._artery.get_name() + " has " + self._rule_text + "."

        return self._rule_text


# General rule text descriptions
general_rule_dictionary = {
    "radius_small": "radius between 0 and 20 voxels",
    "radius_big": "radius greater than 20 voxels",

    "radius_s": "radius between 0 and 20 voxels",
    "radius_m": "radius between 20 and 30 voxels",
    "radius_l": "radius greater than 30 voxels",

    "radius_1": "radius between 0 and 5 voxels",
    "radius_2": "radius between 5 and 10 voxels",
    "radius_3": "radius between 10 and 15 voxels",
    "radius_4": "radius between 15 and 20 voxels",
    "radius_5": "radius between 20 and 25 voxels",
    "radius_6": "radius between 25 and 30 voxels",
    "radius_7": "radius between 30 and 35 voxels",
    "radius_8": "radius between 35 and 40 voxels",
    "radius_9": "radius greater than 40 voxels",


    "quadrant_1": "angle between 0 and 90 degrees",
    "quadrant_2": "angle between 90 and 180 degrees",
    "quadrant_3": "angle between 180 and 270 degrees",
    "quadrant_4": "angle between 270 and 360 degrees",

    "shiftedquadrant_1": "angle between 330 and 360, or between 0 and 60 degrees",
    "shiftedquadrant_2": "angle between 60 and 150 degrees",
    "shiftedquadrant_3": "angle between 150 and 240 degrees",
    "shiftedquadrant_4": "angle between 240 and 330 degrees",

    "semiquadrant_1": "angle between 0 and 45 degrees",
    "semiquadrant_2": "angle between 45 and 90 degrees",
    "semiquadrant_3": "angle between 90 and 135 degrees",
    "semiquadrant_4": "angle between 130 and 180 degrees",
    "semiquadrant_5": "angle between 180 and 225 degrees",
    "semiquadrant_6": "angle between 225 and 270 degrees",
    "semiquadrant_7": "angle between 270 and 315 degrees",
    "semiquadrant_8": "angle between 315 and 360 degrees"
}


# ConfidenceRule has and id and name,
# contains a list of InputArteries
# and a list of IRules
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
        text = "Confidence Rule with ID: [" + \
            str(self._id) + "] and Name: [" + self._name + "].\n"

        for artery in self._arteries:
            text += "\t\tFact: " + str(artery) + "\n"

        for rule in self._rules:
            text += "\t\tRule: " + rule.to_text() + "\n"

        return text


# OutputArtery has and id and name,
# and contains a list of ConfidenceRule
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
        text = "Artery with ID: [" + \
            str(self._id) + "] and Name: [" + self._name + "].\n"

        for confidence_rule in self._confidence_rules:
            text += "\t" + str(confidence_rule) + "\n"

        return (text + "\n")


# To find integers number
number_regex1 = re.compile(r"-?\d+")
number_regex2 = re.compile(r"[+-]\d+")


# Parses in_arteries_classifier.lp file
# and returns a list of all confidence rules found
def parse_arteries_classifier(file_name: str) -> list:
    confidence_rules = []

    with open(file_name, "r") as in_file:
        lines = in_file.readlines()

    for line in lines:
        if line.startswith("confidence_rule"):
            # [0] = confidence rule info, [1...N] = rules
            rules = line.replace("\n", "").split(", ")

           # Extract confidence rule info
            cr_text = rules[0].split("= ")

            id = int(number_regex1.search(cr_text[0]).group(0))
            name = cr_text[1]

            confidence_rule = ConfidenceRule(id, name)

            # Skip [0] because it's confidence rule info
            for i in range(1, len(rules)):
                # [0] = rule name, [1...N] = args
                rule = rules[i].replace("(", ",").replace(")", ",").split(",")

                # main_artery(ID,Z,A,R,N)
                if rule[0] == "main_artery":
                    # If args are not equal to "_", they're valid
                    # If name is equal to "N", it refers to confidence rule principal artery
                    # If name is equal to "N", it refers to confidence rule name
                    id = rule[1] if rule[1] != "_" else None
                    heigth = rule[2] if rule[2] != "_" else None
                    angle = rule[3] if rule[3] != "_" else None
                    radius = rule[4] if rule[4] != "_" else None

                    is_primary = rule[5] == "N"
                    name = rule[5] if rule[5] != "N" else confidence_rule.get_name()

                    artery = InputArtery(ArteryType.Main,
                                         is_primary, name,
                                         id, heigth, angle, radius)
                    confidence_rule.get_arteries().append(artery)

                # bif_artery(ID,R,N)
                elif rule[0] == "bif_artery":
                    # If args are not equal to "_", they're valid
                    # If name is equal to "N", it refers to confidence rule principal artery
                    # If name is equal to "N", it refers to confidence rule name
                    id = rule[1] if rule[1] != "_" else None
                    radius = rule[2] if rule[2] != "_" else None

                    is_primary = rule[3] != "_"
                    name = rule[3] if rule[3] != "N" else confidence_rule.get_name()

                    artery = InputArtery(ArteryType.Biforcation,
                                         is_primary, name,
                                         id, radius=radius)
                    confidence_rule.get_arteries().append(artery)

                # edge(ID1,ID2) or edge(name,ID)
                elif rule[0] == "edge":
                    # Find arteries for ID
                    artery1 = next((artery for artery in confidence_rule.get_arteries()
                                    if artery.get_id() == rule[1]), None)
                    artery2 = next(artery for artery in confidence_rule.get_arteries()
                                   if artery.get_id() == rule[2])

                    # It's edge(name,ID)
                    if artery1 == None:
                        # In this case we only that:
                        # It's a main artery,
                        # Doesn't refer to confidence rule principal artery
                        is_primary = False
                        name = rule[1]

                        artery1 = InputArtery(ArteryType.Main,
                                              is_primary, name)
                        confidence_rule.get_arteries().append(artery1)

                    edge_rule = Edge(artery1, artery2)
                    confidence_rule.get_rules().append(edge_rule)

                # height_greater/height_less(Z1+X1,Z2+X2), with +X1 and +X2 optional
                elif rule[0] == "height_greater" or rule[0] == "height_less":
                    heigth_type = HeigthType.Greater if rule[0] == "height_greater" else HeigthType.Less

                    # Check if there are +X1 and +X2
                    offset_regex1 = number_regex2.search(rule[1])
                    offset_regex2 = number_regex2.search(rule[2])

                    # If success, get the value
                    offset1 = offset_regex1.group(
                        0) if offset_regex1 != None else ""
                    offset2 = offset_regex2.group(
                        0) if offset_regex2 != None else ""

                    # Substring to get the Z
                    heigth1 = rule[1][0: offset_regex1.start(
                    )] if offset_regex1 != None else rule[1]
                    heigth2 = rule[1][0: offset_regex2.start(
                    )] if offset_regex2 != None else rule[2]

                    # Find arteries for Z
                    artery1 = next(artery for artery in confidence_rule.get_arteries()
                                   if artery.get_heigth() == heigth1)
                    artery2 = next(artery for artery in confidence_rule.get_arteries()
                                   if artery.get_heigth() == heigth2)

                    heigth_rule = Heigth(heigth_type,
                                         artery1, offset1,
                                         artery2, offset2)
                    confidence_rule.get_rules().append(heigth_rule)

                # Case when it's a self meaning rule
                else:
                    # Check if it's a general rule contained in general rule dictionary
                    rule_text = general_rule_dictionary.get(rule[0], None)

                    if rule_text != None:
                        # Find primary artery
                        artery = next(artery for artery in confidence_rule.get_arteries()
                                      if artery.get_is_primary)

                        general_rule = General(rule_text, artery)
                        confidence_rule.get_rules().append(general_rule)
                    else:
                        # Parse as generic text rule
                        rules[0] = confidence_rule.get_name() + " has: "
                        rule_text = " ".join(rules)

                        general_rule = General(rule_text)
                        confidence_rule.get_rules().append(general_rule)

                        break

            confidence_rules.append(confidence_rule)

    return confidence_rules


# Parses in_artery_classified.lp file with confidence rules
# and returns a list of all arteries found
def parse_artery_classified(file_name: str, confidence_rules: list) -> list:
    arteries = []

    with open(file_name, "r") as in_file:
        file_content = in_file.read()

    answers = file_content.split("Answer: ")

    # Support variable to find best answer
    facts_text = ""
    optimization_value = 0

    # Skip [0] because of ASP verbose info
    for i in range(1, len(answers)):
        # [0] = answer number (skip), [1] = facts, [2] = optimizazion_value
        answer = answers[i].splitlines()

        tmp_opt_value = number_regex1.search(answer[2]).group(0)
        tmp_opt_value = int(tmp_opt_value)

        # Lower is best
        if tmp_opt_value <= optimization_value:
            optimization_value = tmp_opt_value
            facts_text = answer[1]

    # Can be: artery(id,name) or confidence_rule(name,id)
    for facts in facts_text.split(' '):
        fact = facts.replace("(", ",").replace(")", "").split(",")

        if fact[0] == "artery":
            id = int(fact[1])
            name = fact[2]

            artery = OutputArtery(id, name)
            arteries.append(artery)
        else:
            id = int(fact[2])
            name = fact[1]

            # Find artery associated to confidence rule for name
            artery = next(artery for artery in arteries
                          if artery.get_name() == name)

            # Find associated confidence rule for id and name
            confidence_rule = next(confidence_rule for confidence_rule in confidence_rules
                                   if confidence_rule.get_id() == id and
                                   confidence_rule.get_name() == name)

            artery.get_confidence_rules().append(confidence_rule)

    # Sort for artery id
    arteries.sort(key=lambda artery: artery.get_id())

    return arteries


# Write out_arteries_parsed.txt as text
# and print on terminal if is debug
def write_arteries_parsed(file_name: str, arteries: list, is_debug: bool):
    with open(file_name, "w") as out_file:
        for artery in arteries:
            out_file.write(str(artery))

            if is_debug:
                print(artery)


def main():
    # To simplify debug
    is_debug = True

    if is_debug:
        os.chdir(os.path.dirname(__file__))

        sys.argv.append("arteries_classifier.lp")
        sys.argv.append("out1.lp")
        sys.argv.append("parsed_out1.lp")
    elif (len(sys.argv) < 3) or (not os.path.isfile(sys.argv[1])) or (not os.path.isfile(sys.argv[2])):
        print("Usage: python Parser.py in_arteries_classifier.lp in_arteries_classified.lp out_arteries_parsed.txt")
        exit()

    confidence_rules = parse_arteries_classifier(sys.argv[1])

    arteries = parse_artery_classified(sys.argv[2], confidence_rules)

    write_arteries_parsed(sys.argv[3], arteries, is_debug)


if __name__ == "__main__":
    main()
