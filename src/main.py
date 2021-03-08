import sys
import os

from models_parser import (
    parse_confidence_rule,
    parse_arteries_classifier,
    parse_arteries_classified
)
from utilities import (
    get_md5,
    save_confidence_rules
)
from server import Server


# Write out_arteries_parsed.lp as text
# and print on terminal if is debug
def _write_arteries_parsed(file_name: str, output_models: list, arteries: list, is_debug: bool):
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

        sys.argv.append("Asp/arteries_classifier.lp")
        sys.argv.append("Asp/arteries_classified.lp")
        sys.argv.append("Asp/arteries_parsed.lp")
    elif len(sys.argv) < 3 or not os.path.isfile(sys.argv[1]) or not os.path.isfile(sys.argv[2]):
        print("Usage: python parser.py in_arteries_classifier.lp in_arteries_classified.lp out_arteries_parsed.lp")
        exit()

    database_file_name = "ConfidenceRules.db"
    generated_file_name = "Arteries.svg"
    md5_extension = ".md5"

    classifier_file_name = sys.argv[1]
    classified_file_name = sys.argv[2]
    parsed_file_name = sys.argv[3]

    md5_file_name = os.path.splitext(classifier_file_name)[0]
    md5_file_name += md5_extension

    if not os.path.isfile(md5_file_name):
        with open(md5_file_name, "w") as file:
            file.write("")

    current_md5 = get_md5(classifier_file_name)

    with open(md5_file_name, "r") as file:
        saved_md5 = file.read()

    if current_md5 != saved_md5:
        with open(md5_file_name, "w") as file:
            file.write(current_md5)

        models, confidence_rules = parse_arteries_classifier(
            classifier_file_name)

        models, arteries, dot = parse_arteries_classified(
            classified_file_name, models, confidence_rules)

        _write_arteries_parsed(parsed_file_name, models, arteries, is_debug)
        dot.render(generated_file_name, view=is_debug)

        save_confidence_rules(database_file_name, confidence_rules)
    else:
        confidence_rules = []

        with open(database_file_name, "r") as file:
            for line in file.readlines():
                confidence_rule = parse_confidence_rule(line)

                confidence_rules.append(confidence_rule)

    print("Starting httpd server")
    Server("localhost", 8000, confidence_rules, database_file_name).run()
    print("Sopped httpd server")


if __name__ == "__main__":
    main()
