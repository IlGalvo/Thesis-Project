# Data structures wrappers
from enum import Enum


# Common rule interface
class IRule:
    # To natural language
    def to_text() -> str:
        pass

    # To ASP rule
    def to_rule() -> str:
        pass


# Edge rule referes to two arteries and can be transitive
class Edge(IRule):
    def __init__(self, artery1: str, artery2: str, is_transitive: bool = False):
        self._artery1 = artery1
        self._artery2 = artery2

        self._is_transitive = is_transitive

    def to_text(self) -> str:
        text = self._artery1 + " is "

        if self._is_transitive:
            text += "transitively "

        return text + "connected to " + self._artery2 + "."

    def to_rule(self) -> str:
        if self._artery1 == "aorta":
            if self._is_transitive:
                return "artery(ID,_,_,_,_,_,_,_,_,_,_,N), edge_t(aorta,ID)."
            else:
                return "artery(ID,_,_,_,_,_,_,_,_,_,_,N), edge(aorta,ID)."

        text = "artery(ID1,_,_,_,_,_,_,_,_,_,_,N), "
        text += "artery(ID2,_,_,_,_,_,_,_,_,_,_," + self._artery2 + "), "

        if self._is_transitive:
            return text + "edge_t(ID1,ID2)."

        return text + "edge(ID1,ID2)."


# Comparator rule param types
class ComparatorType(Enum):
    Cog_X = 0
    Cog_Z = 1
    Heigth = 2


# Comparator rule can be greater or less
class ComparatorMode(Enum):
    Greater = 0
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
            text = "artery(_,_,_,_,X1,_,_,_,_,_,_,N), "
            text += "artery(_,_,_,_,X2,_,_,_,_,_,_," + self._artery2 + "), "

            if self._comparator_mode == ComparatorMode.Greater:
                return text + "cog_x_greater(X1" + self._offset1 + ",X2" + self._offset2 + ")."
            else:
                return text + "cog_x_less(X1" + self._offset1 + ",X2" + self._offset2 + ")."
        elif self._comparator_type == ComparatorType.Cog_Z:
            text = "artery(_,_,_,_,_,_,Z1,_,_,_,_,N), "
            text += "artery(_,_,_,_,_,_,Z2,_,_,_,_," + self._artery2 + "), "

            if self._comparator_mode == ComparatorMode.Greater:
                return text + "cog_z_greater(Z1" + self._offset1 + ",Z2" + self._offset2 + ")."
            else:
                return text + "cog_z_less(Z1" + self._offset1 + ",Z2" + self._offset2 + ")."
        else:
            text = "artery(_,_,_,_,_,_,_,_,_,H1,_,N), "
            text += "artery(_,_,_,_,_,_,_,_,_,H2,_," + self._artery2 + "), "

            if self._comparator_mode == ComparatorMode.Greater:
                return text + "height_greater(H1" + self._offset1 + ",H2" + self._offset2 + ")."
            else:
                return text + "height_less(H1" + self._offset1 + ",H2" + self._offset2 + ")."


# General rule has a text description and can refer to an artery
class General(IRule):
    def __init__(self, text: str, artery: str = None):
        self._text = text
        self._artery = artery

    def to_text(self) -> str:
        if self._artery != None:
            return self._artery + " has " + self._text + "."

        return self._text

    def to_rule(self) -> str:
        if self._artery == None:
            return self._text

        index = list(general_rule_dictionary.values()).index(self._text)
        value = list(general_rule_dictionary.keys())[index]

        if self._text.startswith("radius"):
            return "artery(_,R,_,_,_,_,_,_,_,_,_,N), " + value + "(R)."

        return "artery(_,_,_,_,_,_,_,_,_,_,A,N), " + value + "(A)."


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

    def set_rule(self, rule: IRule):
        self._rule = rule

    def to_text(self) -> str:
        text = "Confidence Rule with ID: " + str(self._id)
        text += " and Name: " + self._name + ".\n"

        return text + "\tRule text: " + self._rule.to_text()

    def to_rule(self) -> str:
        text = "confidence_rule(N," + str(self._id)

        return text + ") :- N = " + self._name + ", " + self._rule.to_rule()

    # Confidence rule to json
    def to_json(self) -> str:
        text = "{'id': " + str(self._id) + ", 'name': '" + self._name + "', '"
        text += "text': '" + self.to_text().replace("\t", "")

        return text + "', 'rule': '" + self.to_rule() + "'}"


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
        text = "Artery with ID: " + str(self._id)
        text += " and Name: " + self._name + ".\n"

        for i in range(0, len(self._confidence_rules)):
            text += "\t" + self._confidence_rules[i].to_text()

            if i != len(self._confidence_rules) - 1:
                text += "\n\n"

        return text + "\n"


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
        text = "Model with ID: " + str(self._id)
        text += " and Variant: " + str(self._variant) + ".\n"

        return text + "\tRule text: " + self._edge.to_text() + "\n"


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


# Artery name list
artery_list = [
    "celiac_trunk", "left_gastric", "splenic", "common_hepatic", "proper_hepatic",
    "dorsal_pancreatic", "left_renal", "right_renal", "accessory_left_renal",
    "accessory_right_renal", "gastroduodenal", "left_hepatic", "right_hepatic",
    "superior_mesenteric", "left_intercostal_1", "right_intercostal_1",
    "left_intercostal_2", "right_intercostal_2"
]
