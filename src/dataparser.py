# This file parses the ASP output to natural language.
#
# Usage: python Parser.py in_arteries_classifier.lp
# in_arteries_classified.lpout_arteries_parsed.txt
# where: in_arteries_classifier.lp and in_arteries_classified.lp must be valid
# ASP file.
import re
from graphviz import Digraph

from data import *


# ParamsArtery is primary if it refers to confidence rule
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

    def get_edge(self) -> Edge:
        return self._edge

    def __str__(self) -> str:
        text = "Model with ID: [" + str(self._id) + \
            "] and Variant: [" + str(self._variant) + "].\n"

        return text + "\tRule: " + self._edge.to_text() + "\n\n"


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
            text += "\t" + confidence_rule.to_text() + "\n"

        return (text + "\n")


# To find integers number
number_regex1 = re.compile(r"-?\d+")
number_regex2 = re.compile(r"[+-]\d+")


def parse_model(text: str) -> Model:
    # Cleanup
    text = text.replace("\n", "")
    text = text.replace("(", ",")
    text = text.replace(")", ",")

    # [0] = id, [1] = variant, [2] = artery1, [3] = artery2
    info = text.split(",")

    id = int(info[1])
    variant = int(info[2])
    edge = Edge(info[3], info[4])

    return Model(id, variant, edge)


def parse_confidence_rule(text: str) -> ConfidenceRule:
    # [0] = confidence rule info, [1...N] = rules
    info = text.replace("\n", "").split(", ")

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

            edge = Edge(artery1, artery2, is_transitive)
            confidence_rule.set_rule(edge)

        # cog_x_greater/cog_x_less(X1+n,X2+m), with +n and +m optional
        elif rule[0] == "cog_x_greater" or rule[0] == "cog_x_less":
            comparator_mode = (ComparatorMode.Greater
                               if rule[0] == "cog_x_greater" else ComparatorMode.Less)

            # Check if there are X+n and X+m
            offset_regex1 = number_regex2.search(rule[1])
            offset_regex2 = number_regex2.search(rule[2])

            # If success, get the value
            offset1 = offset_regex1.group(0) if offset_regex1 != None else ""
            offset2 = offset_regex2.group(0) if offset_regex2 != None else ""

            # Substring to get the n and m
            cog_x1 = (rule[1][0: offset_regex1.start()]
                      if offset_regex1 != None else rule[1])
            cog_x2 = (rule[1][0: offset_regex2.start()]
                      if offset_regex2 != None else rule[2])

            # Find arteries for CoG_X
            artery1 = next(artery.get_name() for artery in arteries
                           if artery.get_cog_x() == cog_x1)
            artery2 = next(artery.get_name() for artery in arteries
                           if artery.get_cog_x() == cog_x2)

            comparator = Comparator(ComparatorType.Cog_X, comparator_mode,
                                    artery1, offset1,
                                    artery2, offset2)
            confidence_rule.set_rule(comparator)

        # cog_z_greater/cog_z_less(Z1+n,Z2+m), with +n and +m optional
        elif rule[0] == "cog_z_greater" or rule[0] == "cog_z_less":
            comparator_mode = (ComparatorMode.Greater
                               if rule[0] == "cog_z_greater" else ComparatorMode.Less)

            # Check if there are Z+n and Z+m
            offset_regex1 = number_regex2.search(rule[1])
            offset_regex2 = number_regex2.search(rule[2])

            # If success, get the value
            offset1 = offset_regex1.group(0) if offset_regex1 != None else ""
            offset2 = offset_regex2.group(0) if offset_regex2 != None else ""

            # Substring to get the n and m
            cog_z1 = (rule[1][0: offset_regex1.start()]
                      if offset_regex1 != None else rule[1])
            cog_z2 = (rule[1][0: offset_regex2.start()]
                      if offset_regex2 != None else rule[2])

            # Find arteries for CoG_Z
            artery1 = next(artery.get_name() for artery in arteries
                           if artery.get_cog_z() == cog_z1)
            artery2 = next(artery.get_name() for artery in arteries
                           if artery.get_cog_z() == cog_z2)

            comparator = Comparator(ComparatorType.Cog_Z, comparator_mode,
                                    artery1, offset1,
                                    artery2, offset2)
            confidence_rule.set_rule(comparator)

        # height_greater/height_less(H1+n,H2+m), with +n and +m
        # optional
        elif rule[0] == "height_greater" or rule[0] == "height_less":
            comparator_mode = (ComparatorMode.Greater
                               if rule[0] == "height_greater" else ComparatorMode.Less)

            # Check if there are H+n and H+m
            offset_regex1 = number_regex2.search(rule[1])
            offset_regex2 = number_regex2.search(rule[2])

            # If success, get the value
            offset1 = offset_regex1.group(0) if offset_regex1 != None else ""
            offset2 = offset_regex2.group(0) if offset_regex2 != None else ""

            # Substring to get the n and m
            heigth1 = (rule[1][0: offset_regex1.start()]
                       if offset_regex1 != None else rule[1])
            heigth2 = (rule[1][0: offset_regex2.start()]
                       if offset_regex2 != None else rule[2])

            # Find arteries for Heigth
            artery1 = next(artery.get_name() for artery in arteries
                           if artery.get_heigth() == heigth1)
            artery2 = next(artery.get_name() for artery in arteries
                           if artery.get_heigth() == heigth2)

            comparator = Comparator(ComparatorType.Heigth, comparator_mode,
                                    artery1, offset1,
                                    artery2, offset2)
            confidence_rule.set_rule(comparator)

        # It's a self meaning rule
        else:
            # Check if it's a general rule contained in general rule
            # dictionary
            text = general_rule_dictionary.get(rule[0], None)

            if text != None:
                # Find primary artery
                artery = next(artery.get_name() for artery in arteries
                              if artery.get_is_primary)

                general = General(text, artery)
                confidence_rule.set_rule(general)
            else:
                # Parse as generic text rule
                info[0] = confidence_rule.get_name() + " has: "
                text = " ".join(info)

                general = General(text)
                confidence_rule.set_rule(general)

                break

    return confidence_rule


# Parses in_arteries_classifier.lp file
# and returns a list of all models and confidence rules found
def parse_arteries_classifier(file_name: str):
    models = []
    confidence_rules = []

    with open(file_name, "r") as in_file:
        for line in in_file.readlines():
            if line.startswith("model") and "ID" not in line:
                model = parse_model(line)

                models.append(model)

            elif line.startswith("confidence_rule") and "anatomy" not in line:
                confidence_rule = parse_confidence_rule(line)

                confidence_rules.append(confidence_rule)

    return models, confidence_rules


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
            confidence_rule = next(cr for cr in confidence_rules
                                   if cr.get_id() == id and cr.get_name() == name)

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
