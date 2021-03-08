import hashlib


def get_md5(file_name: str) -> str:
    with open(file_name, "r") as file:
        data = file.read().encode()

        return hashlib.md5(data).hexdigest()


def save_confidence_rules(file_name: str, confidence_rules: list):
    with open(file_name, "w") as file:
        for i in range(0, len(confidence_rules)):
            file.write(confidence_rules[i].to_rule())

            if i != len(confidence_rules) - 1:
                file.write("\n")
