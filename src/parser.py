# This file parses the ASP output to natural language.
#
# Usage: python Parser.py in_arteries_classifier.lp
# in_arteries_classified.lpout_arteries_parsed.txt
# where: in_arteries_classifier.lp and in_arteries_classified.lp must be valid
# ASP file.
import sys
import os
import re
from enum import Enum
from graphviz import Digraph
import json
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs


# ParamsArtery is primary if it refers to confidence rule
class ParamsArtery:
    def __init__(self, is_primary: bool, name: str,
                 id: str=None, radius: str=None, density: str=None, quality: str=None,
                 cog_x: str=None, cog_y: str=None, cog_z: str=None,
                 path_length: str=None, distance_from_extremes: str=None,
                 heigth: str=None, angle: str=None):
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
    def to_text() -> str:
        pass

    def to_rule() -> str:
        pass


# Edge rule referes to two arteries and can be transitive
class Edge(IRule):
    def __init__(self, artery1: str, artery2: str, is_transitive: bool=False):
        self._artery1 = artery1
        self._artery2 = artery2

        self._is_transitive = is_transitive

    def to_text(self) -> str:
        text = self._artery1 + " is"

        if self._is_transitive:
            text += " transitively "

        return text + " connected to " + self._artery2 + "."

    def to_rule(self) -> str:
        if self._artery1 == "aorta":
            if self._is_transitive:
                return "artery(ID,_,_,_,_,_,_,_,_,_,_,N), edge_t(aorta,ID)."
            else:
                return "artery(ID,_,_,_,_,_,_,_,_,_,_,N), edge(aorta,ID)."

        text = "artery(ID1,_,_,_,_,_,_,_,_,_,_,N), artery(ID2,_,_,_,_,_,_,_,_,_,_," + self._artery2 + "), "
        
        if self._is_transitive:
            return text + "edge_t(ID1,ID2)."

        return text + "edge(ID1,ID2)."


# Comparator rule param types
class ComparatorType(Enum):
    Cog_X = 0,
    Cog_Z = 1,
    Heigth = 2,


# Comparator rule can be greater or less
class ComparatorMode(Enum):
    Greater = 0,
    Less = 1


# Comparator rule referes to two arteries and their offsets
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
        if self._comparator_type == ComparatorType.Cog_X:
            comparator_type = " cog_x"
        elif self._comparator_type == ComparatorType.Cog_Z:
            comparator_type = " cog_z"
        else:
            comparator_type = " heigth"

        text = self._artery1 + comparator_type + self._offset1 + " is "

        text += "greater" if self._comparator_mode == ComparatorMode.Greater else "less"

        return text + " than " + self._artery2 + comparator_type + self._offset2 + "."

    def to_rule(self) -> str:
        if self._comparator_type == ComparatorType.Cog_X:
            if self._comparator_mode == ComparatorMode.Greater:
                text = "artery(_,_,_,_,X1,_,_,_,_,_,_,N), artery(_,_,_,_,X2,_,_,_,_,_,_," + self._artery2 + "), "

                return text + "cog_x_greater(X1" + self._offset1 + ",X2" + self._offset2 + ")."
            else:
                text = "artery(_,_,_,_,X1,_,_,_,_,_,_,N), artery(_,_,_,_,X2,_,_,_,_,_,_," + self._artery2 + "), "

                return text + "cog_x_less(X1" + self._offset1 + ",X2" + self._offset2 + ")."

        elif self._comparator_type == ComparatorType.Cog_Z:
            if self._comparator_mode == ComparatorMode.Greater:
                text = "artery(_,_,_,_,_,_,Z1,_,_,_,_,N), artery(_,_,_,_,_,_,Z2,_,_,_,_," + self._artery2 + "), "

                return text + "cog_z_greater(Z1" + self._offset1 + ",Z2" + self._offset2 + ")."
            else:
                text = "artery(_,_,_,_,_,_,Z1,_,_,_,_,N), artery(_,_,_,_,_,_,Z2,_,_,_,_," + self._artery2 + "), "

                return text + "cog_z_less(Z1" + self._offset1 + ",Z2" + self._offset2 + ")."

        else:
            if self._comparator_mode == ComparatorMode.Greater:
                text = "artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_," + self._artery2 + "), "

                return text + "height_greater(H1" + self._offset1 + ",H2" + self._offset2 + ")."
            else:
                text = "artery(_,_,_,_,_,_,_,_,_,H1,_,N), artery(_,_,_,_,_,_,_,_,_,H2,_," + self._artery2 + "), "

                return text + "height_less(H1" + self._offset1 + ",H2" + self._offset2 + ")."


# General rule has a text description and can refer to an artery
class General(IRule):
    def __init__(self, rule_text: str, artery: str=None):
        self._rule_text = rule_text
        self._artery = artery

    def to_text(self) -> str:
        if self._artery != None:
            return self._artery + " has " + self._rule_text + "."

        return self._rule_text

    def to_rule(self) -> str:
        if self._artery == None:
            return self._rule_text

        index = list(general_rule_dictionary.values()).index(self._rule_text)
        value = list(general_rule_dictionary.keys())[index]

        if self._rule_text.startswith("radius"):
            return "artery(_,R,_,_,_,_,_,_,_,_,_,N), " + value + "(R)."

        return "artery(_,_,_,_,_,_,_,_,_,_,A,N), " + value + "(A)."


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


# Model wrapper
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

        return text + "\tRule: " + self._edge.to_text() + "\n\n"


# ConfidenceRule wrapper
class ConfidenceRule(IRule):
    def __init__(self, id: int, name: str):
        self._id = id
        self._name = name

        self._rule = None

    def get_id(self) -> int:
        return self._id

    def get_name(self) -> str:
        return self._name

    def get_rule(self) -> IRule:
        return self._rule

    def set_rule(self, rule:IRule):
        self._rule = rule

    def to_text(self) -> str:
        text = "Confidence Rule with ID: [" + \
            str(self._id) + "] and Name: [" + self._name + "].\n"

        return text + "\t\tRule: " + self._rule.to_text() + "\n"

    def to_rule(self) -> str:
        return "confidence_rule(N," + str(self._id) + ") :- N = " + self._name + ", " + self._rule.to_rule()

    def to_json(self) -> str:
        text = "{'id': " + str(self._id) + ", 'name': '" + self._name + "', '"

        return text + "text': '" + self.to_text() + "', 'rule': '" + self.to_rule() + "'}"


# OutputArtery wrapper
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
# and returns a list of all models and confidence rules found
def parse_arteries_classifier(file_name: str):
    input_models = []
    confidence_rules = []

    with open(file_name, "r") as in_file:
        lines = in_file.readlines()

    for line in lines:
        if line.startswith("model") and "ID" not in line:
            # Cleanup
            line = line.replace("\n", "")
            line = line.replace("(", ",")
            line = line.replace(")", ",")

            # [0] = id, [1] = variant, [2] = artery1, [3] = artery2
            info = line.split(",")

            id = int(info[1])
            variant = int(info[2])
            edge = Edge(info[3], info[4])

            model = Model(id, variant, edge)
            input_models.append(model)

        elif line.startswith("confidence_rule") and "anatomy" not in line:
            # [0] = confidence rule info, [1...N] = rules
            info = line.replace("\n", "").split(", ")

            # Extract confidence rule id and name
            cr_text = info[0].split("= ")

            id = int(number_regex1.search(cr_text[0]).group(0))
            name = cr_text[1]

            confidence_rule = ConfidenceRule(id, name)

            # List of temporary params artery
            arteries = []

            # Skip [0] because it's confidence rule info
            for i in range(1, len(info)):
                # [0] = rule name, [1...N] = args
                rule = info[i].replace("(", ",").replace(")", ",").split(",")

                # artery(ID,R,D,Q,X,Y,Z,PL,DE,H,A,N)
                if rule[0] == "artery":
                    # If args are not equal to "_", they're valid
                    # If name is equal to "N", it refers to confidence rule
                    # principal artery
                    # If name is equal to "N", it refers to confidence rule
                    # name
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
                    confidence_rule.set_rule(edge_rule)

                # cog_x_greater/cog_x_less(X1+n,X2+m), with +n and +m optional
                elif rule[0] == "cog_x_greater" or rule[0] == "cog_x_less":
                    comparator_mode = ComparatorMode.Greater if rule[0] == "cog_x_greater" else ComparatorMode.Less

                    # Check if there are X+n and X+m
                    offset_regex1 = number_regex2.search(rule[1])
                    offset_regex2 = number_regex2.search(rule[2])

                    # If success, get the value
                    offset1 = offset_regex1.group(0) if offset_regex1 != None else ""
                    offset2 = offset_regex2.group(0) if offset_regex2 != None else ""

                    # Substring to get the n and m
                    cog_x1 = rule[1][0: offset_regex1.start()] if offset_regex1 != None else rule[1]
                    cog_x2 = rule[1][0: offset_regex2.start()] if offset_regex2 != None else rule[2]

                    # Find arteries for CoG_X
                    artery1 = next(artery.get_name() for artery in arteries
                                   if artery.get_cog_x() == cog_x1)
                    artery2 = next(artery.get_name() for artery in arteries
                                   if artery.get_cog_x() == cog_x2)

                    cog_x_rule = Comparator(ComparatorType.Cog_X, comparator_mode,
                                            artery1, offset1,
                                            artery2, offset2)
                    confidence_rule.set_rule(cog_x_rule)

                # cog_z_greater/cog_z_less(Z1+n,Z2+m), with +n and +m optional
                elif rule[0] == "cog_z_greater" or rule[0] == "cog_z_less":
                    comparator_mode = ComparatorMode.Greater if rule[0] == "cog_z_greater" else ComparatorMode.Less

                    # Check if there are Z+n and Z+m
                    offset_regex1 = number_regex2.search(rule[1])
                    offset_regex2 = number_regex2.search(rule[2])

                    # If success, get the value
                    offset1 = offset_regex1.group(0) if offset_regex1 != None else ""
                    offset2 = offset_regex2.group(0) if offset_regex2 != None else ""

                    # Substring to get the n and m
                    cog_z1 = rule[1][0: offset_regex1.start()] if offset_regex1 != None else rule[1]
                    cog_z2 = rule[1][0: offset_regex2.start()] if offset_regex2 != None else rule[2]

                    # Find arteries for CoG_Z
                    artery1 = next(artery.get_name() for artery in arteries
                                   if artery.get_cog_z() == cog_z1)
                    artery2 = next(artery.get_name() for artery in arteries
                                   if artery.get_cog_z() == cog_z2)

                    cog_z_rule = Comparator(ComparatorType.Cog_Z, comparator_mode,
                                            artery1, offset1,
                                            artery2, offset2)
                    confidence_rule.set_rule(cog_z_rule)

                # height_greater/height_less(H1+n,H2+m), with +n and +m
                # optional
                elif rule[0] == "height_greater" or rule[0] == "height_less":
                    comparator_mode = ComparatorMode.Greater if rule[0] == "height_greater" else ComparatorMode.Less

                    # Check if there are H+n and H+m
                    offset_regex1 = number_regex2.search(rule[1])
                    offset_regex2 = number_regex2.search(rule[2])

                    # If success, get the value
                    offset1 = offset_regex1.group(0) if offset_regex1 != None else ""
                    offset2 = offset_regex2.group(0) if offset_regex2 != None else ""

                    # Substring to get the n and m
                    heigth1 = rule[1][0: offset_regex1.start()] if offset_regex1 != None else rule[1]
                    heigth2 = rule[1][0: offset_regex2.start()] if offset_regex2 != None else rule[2]

                    # Find arteries for Heigth
                    artery1 = next(artery.get_name() for artery in arteries
                                   if artery.get_heigth() == heigth1)
                    artery2 = next(artery.get_name() for artery in arteries
                                   if artery.get_heigth() == heigth2)

                    heigth_rule = Comparator(ComparatorType.Heigth, comparator_mode,
                                             artery1, offset1,
                                             artery2, offset2)
                    confidence_rule.set_rule(heigth_rule)

                # It's a self meaning rule
                else:
                    # Check if it's a general rule contained in general rule
                    # dictionary
                    rule_text = general_rule_dictionary.get(rule[0], None)

                    if rule_text != None:
                        # Find primary artery
                        artery1 = next(artery.get_name() for artery in arteries
                                       if artery.get_is_primary)

                        general_rule = General(rule_text, artery1)
                        confidence_rule.set_rule(general_rule)
                    else:
                        # Parse as generic text rule
                        info[0] = confidence_rule.get_name() + " has: "
                        rule_text = " ".join(info)

                        general_rule = General(rule_text)
                        confidence_rule.set_rule(general_rule)

                        break

            confidence_rules.append(confidence_rule)

    return input_models, confidence_rules


# Parses in_artery_classified.lp file with confidence rules
# and returns a list of all models, arteries and edge tree structure found
def parse_artery_classified(file_name: str, input_models: list, confidence_rules: list) -> list:
    output_models = []
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

            # Find associated model for id and variant
            model = next(model for model in input_models
                         if model.get_id() == id and model.get_variant() == variant)

            output_models.append(model)

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
                                   if confidence_rule.get_id() == id and confidence_rule.get_name() == name)

            # Find artery associated to confidence rule for name
            artery = next(artery for artery in arteries
                          if artery.get_name() == name)

            artery.get_confidence_rules().append(confidence_rule)

        elif fact[0] == "edge_out":
            artery1 = fact[1]
            artery2 = fact[2]

            # Create tree structure
            dot.edge(artery1, artery2)

    return output_models, arteries, dot


# Write out_arteries_parsed.lp as text
# and print on terminal if is debug
def write_arteries_parsed(file_name: str, output_models: list, arteries: list, is_debug: bool):
    with open(file_name, "w") as out_file:
        for model in output_models:
            out_file.write(str(model))

            if is_debug:
                print(model)

        out_file.write("\n")

        for artery in arteries:
            out_file.write(str(artery))

            if is_debug:
                print(artery)


artery_list = ["celiac_trunk", "left_gastric", "splenic", "common_hepatic", "proper_hepatic",
               "dorsal_pancreatic", "left_renal", "right_renal", "accessory_left_renal",
               "accessory_right_renal", "gastroduodenal", "left_hepatic", "right_hepatic",
               "superior_mesenteric", "left_intercostal_1", "right_intercostal_1",
               "left_intercostal_2", "right_intercostal_2"]

class S(BaseHTTPRequestHandler):
    def set_c_rules(self, confidence_rules:list):
        self._confidence_rules = confidence_rules

    def _set_headers(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()

    def _html(self, message):
        """This just generates an HTML document that includes `message`
        in the body. Override, or re-write this do do more interesting stuff.
        """
        content = f"<html><body><h1>{message}</h1></body></html>"
        return content.encode("utf8")  # NOTE: must return a bytes object!

    def do_GET(self):
        self._set_headers()

        query_path = urlparse(self.path).query
        query_components = parse_qs(query_path)

        if "q" in query_components:
            if "confidence_rules" in query_components["q"]:
                full_text = "["

                for i in range(0, len(self._confidence_rules)):
                    full_text+= self._confidence_rules[i].to_json()
            
                    if i < len(self._confidence_rules) - 1:
                        full_text+=", "

                full_text+="]"
            elif "arteries" in query_components["q"]:
                full_text = json.dumps(artery_list)
            elif "general_rules" in query_components["q"]:
                full_text = json.dumps(list(general_rule_dictionary.values()))
            else:
                full_text = ""

            self.wfile.write(full_text.encode("utf8"))

    def do_HEAD(self):
        self._set_headers()

    def do_POST(self):
        self._set_headers()

        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)

        fields = parse_qs(post_data.decode("utf8"), True)
        full_text = ""
        
        print(fields)

        if "id" in fields and "artery" in fields and "rule_type" in fields:
            id = fields["id"][0]
            artery = fields["artery"][0]

            rule_type = fields["rule_type"][0]

            if rule_type == "general" and "text" in fields:
                text = fields["text"][0]

                cr = ConfidenceRule(id, artery)
                cr.set_rule(General(text, artery))

                full_text += cr.to_json()
            elif rule_type == "comparator" and "type" in fields and "mode" in fields and "offset1" in fields and "artery2" in fields and "offset2" in fields:
                type = fields["type"][0]

                if type == "cog_x":
                    type = ComparatorType.Cog_X
                elif type == "cog_z":
                    type = ComparatorType.Cog_Z
                else:
                    type = ComparatorType.Heigth

                mode = ComparatorMode.Greater if ["mode"][0] == "greater" else "less"

                offset1 = fields["offset1"][0]

                artery2 = fields["artery2"][0]
                offset2 = fields["offset2"][0]
                
                cr = ConfidenceRule(id, artery)
                cr.set_rule(Comparator(type, mode, artery, offset1, artery2, offset2))

                full_text += cr.to_json()
            elif rule_type == "edge" and "artery2" in fields and "is_transitive" in fields:
                artery2 = fields["artery2"][0]
                is_transitive = True if fields["is_transitive"][0] == "true" else False

                cr = ConfidenceRule(id, artery)
                cr.set_rule(Edge(artery, artery2, is_transitive))

                full_text += cr.to_json()

        self.wfile.write(full_text.encode("utf8"))


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

    models, confidence_rules = parse_arteries_classifier(sys.argv[1])

    models, arteries, dot = parse_artery_classified(sys.argv[2], models, confidence_rules)

    #write_arteries_parsed(sys.argv[3], models, arteries, is_debug)
    #dot.render("Arteries.svg", view=is_debug)

    server_address = ("localhost", 8000)
    httpd = HTTPServer(server_address, S)
    httpd.RequestHandlerClass.set_c_rules(httpd.RequestHandlerClass, confidence_rules)

    print("Starting httpd server")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    print("Sopped httpd server")

if __name__ == "__main__":
    main()
