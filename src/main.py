import sys
import os
import hashlib

from server import Server


def get_md5(file_name: str) -> str:
    with open(file_name, "r") as file:
        data = file.read().encode()

        return hashlib.md5(data).hexdigest()


def save_confidence_rules(file_name:str, confidence_rules:list):
    with open(file_name, "w") as file:
            for i in range(0, len(confidence_rules)):
                file.write(confidence_rules[i].to_rule())

                if i != len(confidence_rules) - 1:
                    file.write("\n")


def import_confidence_rules(file_name:str) -> list:
    with open(file_name, "r") as file:
            for line in file.readlines():
                confidence_rule = parse_confidence_rule(line)

                confidence_rules.append(confidence_rule)


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

    md5_file_name = os.path.splitext(sys.argv[1])[0] + ".md5"

    if not os.path.isfile(md5_file_name):
        with open(md5_file_name, "w") as md5_file:
            md5_file.write("")

    md5_1 = get_md5(sys.argv[1])

    with open(md5_file_name, "r") as md5_file:
        md5_2 = md5_file.read()

    if md5_1 != md5_2:
        with open(md5_file_name, "w") as md5_file:
            md5_file.write(md5_1)

        models, confidence_rules = parse_arteries_classifier(sys.argv[1])

        models, arteries, dot = parse_artery_classified(sys.argv[2], models, confidence_rules)

        write_arteries_parsed(sys.argv[3], models, arteries, is_debug)
        dot.render("Arteries.svg", view=is_debug)

        save_confidence_rules("confidence_rules.db", confidence_rules)
    else:
        confidence_rules = import_confidence_rules("confidence_rules.db")

    print("Starting httpd server")
    Server("192.168.1.5", 8000, confidence_rules).run()
    print("Sopped httpd server")


if __name__ == "__main__":
    main()