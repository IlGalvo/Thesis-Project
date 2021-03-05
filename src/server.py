from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import json

from data import *
import main


class ServerHandler(BaseHTTPRequestHandler):
    def set_confidence_rules(self, confidence_rules: list):
        self._confidence_rules = confidence_rules

    def _confidence_rules_to_json(self):
        text = "["

        for i in range(0, len(self._confidence_rules)):
            text += self._confidence_rules[i].to_json()

            if i < len(self._confidence_rules) - 1:
                text += ", "

        return text + "]"

    def _log(self, text: str):
        with open("server_log.txt", "a+") as log_file:
            log_file.write(text + "\n")

    def _set_ok_headers(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()

    def _set_ko_headers(self):
        self.send_response(400)
        self.send_header("Content-type", "text/plain")
        self.end_headers()

    def _write_ok_response(self, text:str):
        self._set_ok_headers()

        self.wfile.write(text.encode("utf8"))

    def _write_ko_response(self, text:str):
        self._set_ko_headers()

        self.wfile.write(text.encode("utf8"))

    def _write_add_confidence_rule(self, confidence_rule:ConfidenceRule):
        self._confidence_rules.append(confidence_rule)

        text = confidence_rule.to_json()
        self._write_ok_response(text)

        self._log("[INSERT]: " + confidence_rule.to_rule())
        main.save_confidence_rules("confidence_rules.db", self._confidence_rules)

    def do_GET(self):
        query_path = urlparse(self.path).query
        query_components = parse_qs(query_path)

        if "q" in query_components:
            if "confidence_rules" in query_components["q"]:
                text = self._confidence_rules_to_json()
                self._write_ok_response(text)
            elif "arteries" in query_components["q"]:
                text = json.dumps(artery_list)
                self._write_ok_response(text)
            elif "general_texts" in query_components["q"]:
                text = json.dumps(list(general_rule_dictionary.values()))
                self._write_ok_response(text)
            elif "comparator_types" in query_components["q"]:
                text = json.dumps([ctype.name for ctype in ComparatorType])
                self._write_ok_response(text)
            elif "comparator_modes" in query_components["q"]:
                text = json.dumps([cmode.name for cmode in ComparatorMode])
                self._write_ok_response(text)
            else:
                text = "ToDo: Handle 400 Error"
                self._write_ko_response(text)
        else:
            text = "ToDo: Handle 400 Error"
            self._write_ko_response(text)

    def do_HEAD(self):
        self._set_ok_headers()

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

                    iterator = filter(lambda confidence_rule: confidence_rule.get_name() == main_artery, self._confidence_rules)
                    id = max(iterator, key=lambda confidence_rule: confidence_rule.get_id()).get_id()

                    if rule_type == "edge" and "artery" in post_fields and "is_transitive" in post_fields:
                        artery = post_fields["artery"][0]
                        is_transitive = json.loads(post_fields["is_transitive"][0].lower())

                        confidence_rule = ConfidenceRule(id, main_artery)
                        confidence_rule.set_rule(Edge(main_artery, artery, is_transitive))

                        self._write_add_confidence_rule(confidence_rule)
                    elif rule_type == "comparator" and "type" in post_fields and "mode" in post_fields and "offset1" in post_fields and "artery" in post_fields and "offset2" in post_fields:
                        type = post_fields["type"][0]
                        type = ComparatorType[type]

                        mode = post_fields["mode"][0]
                        mode = ComparatorMode[mode]

                        offset1 = post_fields["offset1"][0]

                        artery = post_fields["artery"][0]
                        offset2 = post_fields["offset2"][0]

                        confidence_rule = ConfidenceRule(id, main_artery)
                        confidence_rule.set_rule(Comparator(type, mode, main_artery, offset1, artery, offset2))

                        self._write_add_confidence_rule(confidence_rule)
                    elif rule_type == "general" and "text" in post_fields:
                        text = post_fields["text"][0]

                        confidence_rule = ConfidenceRule(id, main_artery)
                        confidence_rule.set_rule(General(text, main_artery))

                        self._write_add_confidence_rule(confidence_rule)
                    else:
                        text = "ToDo: Handle 400 Error"
                        self._write_ko_response(text)
                else:
                    text = "ToDo: Handle 400 Error"
                    self._write_ko_response(text)
            elif "delete" in query_components["action"]:
                if "id" in post_fields and "name" in post_fields:
                    id = int(post_fields["id"][0])
                    name = post_fields["name"][0]

                    confidence_rule = next((confidence_rule for confidence_rule in self._confidence_rules
                                            if confidence_rule.get_id() == id and confidence_rule.get_name() == name), None)

                    if confidence_rule != None:
                        self._confidence_rules.remove(confidence_rule)

                        self._set_ok_headers()

                        self._log("[DELETED]: " + confidence_rule.to_rule())
                        main.save_confidence_rules("confidence_rules.db", self._confidence_rules)
                    else:
                        text = "ToDo: Handle 400 Error"
                        self._write_ko_response(text)
                else:
                    text = "ToDo: Handle 400 Error"
                    self._write_ko_response(text)
            else:
                text = "ToDo: Handle 400 Error"
                self._write_ko_response(text)
        else:
            text = "ToDo: Handle 400 Error"
            self._write_ko_response(text)


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