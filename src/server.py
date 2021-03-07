from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import json

from data import *
from utilities import save_confidence_rules


class ServerHandler(BaseHTTPRequestHandler):
    def set_confidence_rules(self, confidence_rules: list):
        self._confidence_rules = confidence_rules

    def __confidence_rules_to_json(self) -> str:
        text = "["

        for i in range(0, len(self._confidence_rules)):
            text += self._confidence_rules[i].to_json()

            if i < len(self._confidence_rules) - 1:
                text += ", "

        return text + "]"

    def __get_next_id(self, name: str) -> int:
        iterator = filter((lambda cr: cr.get_name() == name),
                          self._confidence_rules)
        confidence_rule = max(iterator, default=None,
                              key=(lambda cr: cr.get_id()))

        return confidence_rule.get_id() + 1 if confidence_rule != None else 0

    def __send_ok_headers(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()

    def __send_ko_headers(self):
        self.send_response(400)
        self.send_header("Content-type", "text/plain")
        self.end_headers()

    def __send_ok_response(self, text: str):
        self.__send_ok_headers()

        self.wfile.write(text.encode("utf8"))

    def __send_ko_response(self, text: str):
        self.__send_ko_headers()

        self.wfile.write(text.encode("utf8"))

    @staticmethod
    def __log(text: str):
        with open("server_log.txt", "a+") as log_file:
            log_file.write(text + "\n")

    def __handle_added_confidence_rule(self, confidence_rule: ConfidenceRule):
        self._confidence_rules.append(confidence_rule)

        text = confidence_rule.to_json()
        self.__send_ok_response(text)

        self.__log("[INSERT]: " + confidence_rule.to_rule())
        save_confidence_rules("confidence_rules.db", self._confidence_rules)

    def __handle_removed_confidence_rule(self, confidence_rule: ConfidenceRule):
        self._confidence_rules.remove(confidence_rule)

        self.__send_ok_headers()

        self.__log("[DELETED]: " + confidence_rule.to_rule())
        save_confidence_rules("confidence_rules.db", self._confidence_rules)

    def do_GET(self):
        query_path = urlparse(self.path).query
        query_components = parse_qs(query_path)

        if "q" in query_components:
            if "confidence_rules" in query_components["q"]:
                text = self.__confidence_rules_to_json()
                self.__send_ok_response(text)
            elif "arteries" in query_components["q"]:
                text = json.dumps(artery_list)
                self.__send_ok_response(text)
            elif "general_texts" in query_components["q"]:
                text = json.dumps(list(general_rule_dictionary.values()))
                self.__send_ok_response(text)
            elif "comparator_types" in query_components["q"]:
                text = json.dumps([ctype.name for ctype in ComparatorType])
                self.__send_ok_response(text)
            elif "comparator_modes" in query_components["q"]:
                text = json.dumps([cmode.name for cmode in ComparatorMode])
                self.__send_ok_response(text)
            else:
                text = "ToDo: Handle 400 Error"
                self.__send_ko_response(text)
        else:
            text = "ToDo: Handle 400 Error"
            self.__send_ko_response(text)

    def do_HEAD(self):
        self.__send_ok_headers()

    def do_POST(self):
        query_path = urlparse(self.path).query
        query_components = parse_qs(query_path)

        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)

        post_fields = parse_qs(post_data.decode("utf8"), True)

        if "action" in query_components:
            if "insert" in query_components["action"]:
                if "main_artery" in post_fields and "rule_type" in post_fields:
                    main_artery = post_fields["main_artery"][0]
                    rule_type = post_fields["rule_type"][0]

                    id = self.__get_next_id(main_artery)

                    if rule_type == "edge" and "artery" in post_fields and "is_transitive" in post_fields:
                        artery = post_fields["artery"][0]
                        is_transitive = json.loads(
                            post_fields["is_transitive"][0].lower())

                        confidence_rule = ConfidenceRule(id, main_artery)

                        if artery == "aorta":
                            edge = Edge(artery, main_artery, is_transitive)
                            confidence_rule.set_rule(edge)
                        else:
                            edge = Edge(main_artery, artery, is_transitive)
                            confidence_rule.set_rule(edge)

                        self.__handle_added_confidence_rule(confidence_rule)
                    elif rule_type == "comparator" and "type" in post_fields and "mode" in post_fields and \
                            "offset1" in post_fields and "artery" in post_fields and "offset2" in post_fields:
                        type = post_fields["type"][0]
                        type = ComparatorType[type]

                        mode = post_fields["mode"][0]
                        mode = ComparatorMode[mode]

                        offset1 = post_fields["offset1"][0]

                        artery = post_fields["artery"][0]
                        offset2 = post_fields["offset2"][0]

                        confidence_rule = ConfidenceRule(id, main_artery)

                        comparator = Comparator(type, mode,
                                                main_artery, offset1,
                                                artery, offset2)
                        confidence_rule.set_rule(comparator)

                        self.__handle_added_confidence_rule(confidence_rule)
                    elif rule_type == "general" and "text" in post_fields:
                        text = post_fields["text"][0]

                        confidence_rule = ConfidenceRule(id, main_artery)

                        general = General(text, main_artery)
                        confidence_rule.set_rule(general)

                        self.__handle_added_confidence_rule(confidence_rule)
                    else:
                        text = "ToDo: Handle 400 Error"
                        self.__send_ko_response(text)
                else:
                    text = "ToDo: Handle 400 Error"
                    self.__send_ko_response(text)
            elif "delete" in query_components["action"]:
                if "id" in post_fields and "name" in post_fields:
                    id = int(post_fields["id"][0])
                    name = post_fields["name"][0]

                    confidence_rule = next((cr for cr in self._confidence_rules
                                            if cr.get_id() == id and cr.get_name() == name), None)

                    if confidence_rule != None:
                        self.__handle_removed_confidence_rule(confidence_rule)
                    else:
                        text = "ToDo: Handle 400 Error"
                        self.__send_ko_response(text)
                else:
                    text = "ToDo: Handle 400 Error"
                    self.__send_ko_response(text)
            else:
                text = "ToDo: Handle 400 Error"
                self.__send_ko_response(text)
        else:
            text = "ToDo: Handle 400 Error"
            self.__send_ko_response(text)


class Server:
    def __init__(self, ip: str, port: int, confidence_rules: list):
        self._http_server = HTTPServer((ip, port), ServerHandler)

        handler = self._http_server.RequestHandlerClass
        handler.set_confidence_rules(handler, confidence_rules)

    def run(self):
        try:
            self._http_server.serve_forever()
        except KeyboardInterrupt:
            pass

        self._http_server.server_close()
