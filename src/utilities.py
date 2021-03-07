def save_confidence_rules(file_name: str, confidence_rules: list):
    with open(file_name, "w") as file:
        for i in range(0, len(confidence_rules)):
            file.write(confidence_rules[i].to_rule())

            if i != len(confidence_rules) - 1:
                file.write("\n")
