# This file parses the ASP output to natural language.
#
# Usage: python Parser.py in_arteries_classifier.lp in_arteries_classified.lpout_arteries_parsed.txt
# where: in_arteries_classifier.lp and in_arteries_classified.lp must be valid ASP file.

import sys
import os
import re
from enum import Enum
from graphviz import Digraph


# ParamsArtery has type,
# is primary if it refers to confidence rule,
# has a name
# and id, heigth, angle and radius are optional
class ParamsArtery:
    def __init__(self, is_primary: bool, name: str,
                 id: str = None, radius: str = None, density: str = None, quality: str = None,
                 cog_x: str = None, cog_y: str = None, cog_z: str = None,
                 path_length: str = None, distance_from_extremes: str = None,
                 heigth: str = None, angle: str = None):
        self._is_primary = is_primary
        self._name = name

        self._id = id
        self._radius = radius
        self._density = density
        self._quality = quality

        self._cog_x = cog_x
        self._cog_y = cog_y
        self._cog_z = cog_z

        self._path_length = path_length
        self._distance_from_extremes = distance_from_extremes

        self._heigth = heigth
        self._angle = angle

    def get_is_primary(self) -> bool:
        return self._is_primary

    def get_name(self) -> str:
        return self._name

    def get_id(self) -> str:
        return self._id

    def get_radius(self) -> str:
        return self._radius

    def get_density(self) -> str:
        return self._density

    def get_quality(self) -> str:
        return self._quality

    def get_cog_x(self) -> str:
        return self._cog_x

    def get_cog_y(self) -> str:
        return self._cog_y

    def get_cog_z(self) -> str:
        return self._cog_z

    def get_path_length(self) -> str:
        return self._path_length

    def get_distance_from_extremes(self) -> str:
        return self._distance_from_extremes

    def get_heigth(self) -> str:
        return self._heigth

    def get_angle(self) -> str:
        return self._angle

    def __str__(self) -> str:
        return self._name + " is an artery."


# Common rule interface
class IRule:
    def to_text(self) -> str:
        pass


# Edge rule referes to two arteries IDs
class Edge(IRule):
    def __init__(self, artery1: str, artery2: str, is_transitive: bool = False):
        self._artery1 = artery1
        self._artery2 = artery2

        self._is_transitive = is_transitive

    def to_text(self) -> str:
        return self.__str__()

    def __str__(self) -> str:
        text = self._artery1 + " is "

        if self._is_transitive:
            text += "transitively "

        return text + " connected to " + self._artery2 + "."


# Comparator rule can be: ToDo
class ComparatorType(Enum):
    Cog_X = 0,
    Cog_Z = 1,
    Heigth = 2,


# Comparator rule can be greater or less
class ComparatorMode(Enum):
    Greater = 0,
    Less = 1


# Comparator rule referes to two arteries values and their offsets
class Comparator(IRule):
    def __init__(self, comparator_type: ComparatorType, comparator_mode: ComparatorMode,
                 artery1: str, offset1: str,
                 artery2: str, offset2: str):
        self._comparator_type = comparator_type
        self._comparator_mode = comparator_mode

        self._artery1 = artery1
        self._offset1 = offset1

        self._artery2 = artery2
        self._offset2 = offset2

    def to_text(self) -> str:
        return self.__str__()

    def __str__(self) -> str:
        if self._comparator_type == ComparatorType.Cog_X:
            comparator_type = " center of gravity x"
        elif self._comparator_type == ComparatorType.Cog_Z:
            comparator_type = " center of gravity z"
        else:
            comparator_type = " heigth"

        text = self._artery1 + comparator_type + self._offset1 + " is "

        text += "greater" if self._comparator_mode == ComparatorMode.Greater else "less"

        return text + " than " + self._artery2 + comparator_type + self._offset2 + "."


# General rule has a text description and can refer to an artery
class General(IRule):
    def __init__(self, rule_text: str, artery: str = None):
        self._rule_text = rule_text
        self._artery = artery

    def to_text(self) -> str:
        return self.__str__()

    def __str__(self) -> str:
        if self._artery != None:
            return self._artery + " has " + self._rule_text + "."

        return self._rule_text


# General rule text descriptions
general_rule_dictionary = {
    "radius_small": "radius between 0 and 20 voxels",
    "radius_big": "radius greater than 20 voxels",

    "radius_s": "radius between 0 and 10 voxels",
    "radius_m": "radius between 10 and 20 voxels",
    "radius_l": "radius greater than 20 voxels",

    "radius_0_5": "radius between 0 and 5 voxels",
    "radius_5_10": "radius between 5 and 10 voxels",
    "radius_10_15": "radius between 10 and 15 voxels",
    "radius_15_20": "radius between 15 and 20 voxels",
    "radius_20_25": "radius between 20 and 25 voxels",
    "radius_25_30": "radius between 25 and 30 voxels",
    "radius_30_35": "radius between 30 and 35 voxels",
    "radius_35_40": "radius between 35 and 40 voxels",
    "radius_40": "radius greater than 40 voxels",


    "quadrant_1": "angle between 45 and 90 degrees, or between 90 and 135 degrees",
    "quadrant_2": "angle between 135 and 180 degrees, or between 180 and 225 degrees",
    "quadrant_3": "angle between 225 and 270 degrees, or between 270 and 315 degrees",
    "quadrant_4": "angle between 315 and 360 degrees, or between 0 and 45 degrees",

    "semiquadrant_1": "angle between 0 and 45 degrees",
    "semiquadrant_2": "angle between 45 and 90 degrees",
    "semiquadrant_3": "angle between 90 and 135 degrees",
    "semiquadrant_4": "angle between 130 and 180 degrees",
    "semiquadrant_5": "angle between 180 and 225 degrees",
    "semiquadrant_6": "angle between 225 and 270 degrees",
    "semiquadrant_7": "angle between 270 and 315 degrees",
    "semiquadrant_8": "angle between 315 and 360 degrees"
}


# Tmp
class Model:
    def __init__(self, id: int, variant: int, edge: Edge):
        self._id = id
        self._variant = variant

        self._edge = edge

    def get_id(self) -> int:
        return self._id

    def get_variant(self) -> int:
        return self._variant

    def get_artery1(self) -> str:
        return self._artery1

    def get_artery2(self) -> str:
        return self._artery2

    def __str__(self) -> str:
        text = "Model with ID: [" + str(self._id) + \
            "] and Variant: [" + str(self._variant) + "].\n"

        return text + "\tRule: " + self._edge.to_text() + "\n"


# ConfidenceRule has and id and name,
# contains a list of InputArteries
# and a list of IRules
class ConfidenceRule:
    def __init__(self, id: int, name: str):
        self._id = id
        self._name = name

        self._rules = []

    def get_id(self) -> int:
        return self._id

    def get_name(self) -> str:
        return self._name

    def get_rules(self) -> list:
        return self._rules

    def __str__(self) -> str:
        text = "Confidence Rule with ID: [" + \
            str(self._id) + "] and Name: [" + self._name + "].\n"

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
def parse_arteries_classifier2(file_name: str):
    with open(file_name, "r") as in_file:
        lines = in_file.readlines()

    models = []
    confidence_rules = []

    for line in lines:
        if line.startswith("model") and "ID" not in line:
            info = line.replace("\n", "").replace(
                "(", ",").replace(")", ",").split(",")

            id = int(info[1])
            variant = int(info[2])
            edge = Edge(info[3], info[4])

            model = Model(id, variant, edge)
            models.append(model)

        elif line.startswith("confidence_rule") and "anatomy" not in line:
            # [0] = confidence rule info, [1...N] = rules
            info = line.replace("\n", "").split(", ")

            # Extract confidence rule id and name
            cr_text = info[0].split("= ")

            id = int(number_regex1.search(cr_text[0]).group(0))
            name = cr_text[1]

            confidence_rule = ConfidenceRule(id, name)

            # Temp
            arteries = []

            # Skip [0] because it's confidence rule info
            for i in range(1, len(info)):
                # [0] = rule name, [1...N] = args
                rule = info[i].replace("(", ",").replace(")", ",").split(",")

                # artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N)
                if rule[0] == "artery":
                    # If args are not equal to "_", they're valid
                    # If name is equal to "N", it refers to confidence rule principal artery
                    # If name is equal to "N", it refers to confidence rule name
                    id = rule[1] if rule[1] != "_" else None
                    radius = rule[2] if rule[2] != "_" else None
                    density = rule[3] if rule[3] != "_" else None
                    quality = rule[4] if rule[4] != "_" else None
                    cog_x = rule[5] if rule[5] != "_" else None
                    cog_y = rule[6] if rule[6] != "_" else None
                    cog_z = rule[7] if rule[7] != "_" else None
                    path_length = rule[8] if rule[8] != "_" else None
                    distance_from_extremes = rule[9] if rule[9] != "_" else None
                    heigth = rule[10] if rule[10] != "_" else None
                    angle = rule[11] if rule[11] != "_" else None

                    is_primary = rule[12] == "N"
                    name = rule[12] if rule[12] != "N" else confidence_rule.get_name()

                    artery = ParamsArtery(is_primary, name,
                                          id, radius, density, quality,
                                          cog_x, cog_y, cog_z,
                                          path_length, distance_from_extremes,
                                          heigth, angle)
                    arteries.append(artery)

                # edge(ID1,ID2) or edge(name,ID)
                elif rule[0] == "edge" or rule[0] == "edge_t":
                    # Find arteries for ID
                    artery1 = next((artery.get_name() for artery in arteries
                                    if artery.get_id() == rule[1]), rule[1])
                    artery2 = next(artery.get_name() for artery in arteries
                                   if artery.get_id() == rule[2])

                    is_transitive = rule[0] == "edge_t"

                    edge_rule = Edge(artery1, artery2, is_transitive)
                    confidence_rule.get_rules().append(edge_rule)

                # height_greater/height_less(Z1+X1,Z2+X2), with +X1 and +X2 optional
                elif rule[0] == "height_greater" or rule[0] == "height_less":
                    comparator_mode = ComparatorMode.Greater if rule[
                        0] == "height_greater" else ComparatorMode.Less

                    # Check if there are H+n and H+m
                    offset_regex1 = number_regex2.search(rule[1])
                    offset_regex2 = number_regex2.search(rule[2])

                    # If success, get the value
                    offset1 = offset_regex1.group(
                        0) if offset_regex1 != None else ""
                    offset2 = offset_regex2.group(
                        0) if offset_regex2 != None else ""

                    # Substring to get the n and m
                    heigth1 = rule[1][0: offset_regex1.start(
                    )] if offset_regex1 != None else rule[1]
                    heigth2 = rule[1][0: offset_regex2.start(
                    )] if offset_regex2 != None else rule[2]

                    # Find arteries for Heigth
                    artery1 = next(artery.get_name() for artery in arteries
                                   if artery.get_heigth() == heigth1)
                    artery2 = next(artery.get_name() for artery in arteries
                                   if artery.get_heigth() == heigth2)

                    heigth_rule = Comparator(ComparatorType.Heigth, comparator_mode,
                                             artery1, offset1,
                                             artery2, offset2)
                    confidence_rule.get_rules().append(heigth_rule)

                elif rule[0] == "cog_x_greater" or rule[0] == "cog_x_less":
                    comparator_mode = ComparatorMode.Greater if rule[
                        0] == "cog_x_greater" else ComparatorMode.Less

                    # Check if there are X+n and X+m
                    offset_regex1 = number_regex2.search(rule[1])
                    offset_regex2 = number_regex2.search(rule[2])

                    # If success, get the value
                    offset1 = offset_regex1.group(
                        0) if offset_regex1 != None else ""
                    offset2 = offset_regex2.group(
                        0) if offset_regex2 != None else ""

                    # Substring to get the n and m
                    cog_x1 = rule[1][0: offset_regex1.start(
                    )] if offset_regex1 != None else rule[1]
                    cog_x2 = rule[1][0: offset_regex2.start(
                    )] if offset_regex2 != None else rule[2]

                    # Find arteries for CoG_X
                    artery1 = next(artery.get_name() for artery in arteries
                                   if artery.get_cog_x() == cog_x1)
                    artery2 = next(artery.get_name() for artery in arteries
                                   if artery.get_cog_x() == cog_x2)

                    cog_x_rule = Comparator(ComparatorType.Cog_X, comparator_mode,
                                            artery1, offset1,
                                            artery2, offset2)
                    confidence_rule.get_rules().append(cog_x_rule)

                elif rule[0] == "cog_z_greater" or rule[0] == "cog_z_less":
                    comparator_mode = ComparatorMode.Greater if rule[
                        0] == "cog_z_greater" else ComparatorMode.Less

                    # Check if there are Z+n and Z+m
                    offset_regex1 = number_regex2.search(rule[1])
                    offset_regex2 = number_regex2.search(rule[2])

                    # If success, get the value
                    offset1 = offset_regex1.group(
                        0) if offset_regex1 != None else ""
                    offset2 = offset_regex2.group(
                        0) if offset_regex2 != None else ""

                    # Substring to get the n and m
                    cog_z1 = rule[1][0: offset_regex1.start(
                    )] if offset_regex1 != None else rule[1]
                    cog_z2 = rule[1][0: offset_regex2.start(
                    )] if offset_regex2 != None else rule[2]

                    # Find arteries for CoG_Z
                    artery1 = next(artery.get_name() for artery in arteries
                                   if artery.get_cog_z() == cog_z1)
                    artery2 = next(artery.get_name() for artery in arteries
                                   if artery.get_cog_z() == cog_z2)

                    cog_z_rule = Comparator(ComparatorType.Cog_Z, comparator_mode,
                                            artery1, offset1,
                                            artery2, offset2)
                    confidence_rule.get_rules().append(cog_z_rule)

                # It's a self meaning rule
                else:
                    # Check if it's a general rule contained in general rule dictionary
                    rule_text = general_rule_dictionary.get(rule[0], None)

                    if rule_text != None:
                        # Find primary artery
                        artery1 = next(artery.get_name() for artery in arteries
                                       if artery.get_is_primary)

                        general_rule = General(rule_text, artery1)
                        confidence_rule.get_rules().append(general_rule)
                    else:
                        # Parse as generic text rule
                        info[0] = confidence_rule.get_name() + " has: "
                        rule_text = " ".join(info)

                        general_rule = General(rule_text)
                        confidence_rule.get_rules().append(general_rule)

                        break

            confidence_rules.append(confidence_rule)

    return models, confidence_rules


# Parses in_artery_classified.lp file with confidence rules
# and returns a list of all arteries found
def parse_artery_classified2(file_name: str, models: list, confidence_rules: list) -> list:
    models2 = []
    arteries = []
    dot = Digraph(comment='Arteries')

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

        if fact[0] == "model_gen":
            id = int(fact[1])
            variant = int(fact[2])

            model = next(model for model in models
                         if model.get_id() == id and
                         model.get_variant() == variant)

            models2.append(model)
        elif fact[0] == "out_artery":
            id = int(fact[1])
            name = fact[2]

            artery = OutputArtery(id, name)
            arteries.append(artery)
        elif fact[0] == "cleaned_cr":
            id = int(fact[2])
            name = fact[1]

            # Find associated confidence rule for id and name
            confidence_rule = next(confidence_rule for confidence_rule in confidence_rules
                                   if confidence_rule.get_id() == id and
                                   confidence_rule.get_name() == name)

            # Find artery associated to confidence rule for name
            artery = next(artery for artery in arteries
                          if artery.get_name() == name)

            artery.get_confidence_rules().append(confidence_rule)
        elif fact[0] == "edge_out":
            artery1 = fact[1]
            artery2 = fact[2]

            dot.edge(artery1, artery2)

    # Sort for artery id
    arteries.sort(key=lambda artery: artery.get_id())

    return models2, arteries, dot


def main():
    # To simplify debug
    is_debug = True

    if is_debug:
        os.chdir(os.path.dirname(__file__))

        sys.argv.append("arteries_classifier.lp")
        sys.argv.append("arteries_classified.lp")
        sys.argv.append("arteries_parsed.lp")
    elif len(sys.argv) < 3 or not os.path.isfile(sys.argv[1]) or not os.path.isfile(sys.argv[2]):
        print("Usage: python parser.py in_arteries_classifier.lp in_arteries_classified.lp out_arteries_parsed.lp")
        exit()

    x, y = parse_arteries_classifier2(sys.argv[1])

    x, y, z = parse_artery_classified2(sys.argv[2], x, y)

    for model in x:
        print(model)
    for artery in y:
        print(artery)
    z.render("Arteries.svg", view=is_debug)

    exit()


if __name__ == "__main__":
    main()
