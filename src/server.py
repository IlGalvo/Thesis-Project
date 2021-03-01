from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import json

from data import *
import main


class ServerHandler(BaseHTTPRequestHandler):
    def set_c_rules(self, confidence_rules: list):
        self._confidence_rules = confidence_rules

    def _log(self, text):
        with open("server_log.txt", "a+") as log_file:
            log_file.write(text + "\n")

    def _set_headers(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()

    def do_GET(self):
        self._set_headers()

        query_path = urlparse(self.path).query
        query_components = parse_qs(query_path)

        if "q" in query_components:
            if "confidence_rules" in query_components["q"]:
                full_text = "["

                for i in range(0, len(self._confidence_rules)):
                    full_text += self._confidence_rules[i].to_json()

                    if i < len(self._confidence_rules) - 1:
                        full_text += ", "

                full_text += "]"
            elif "arteries" in query_components["q"]:
                full_text = json.dumps(artery_list)
            elif "general_texts" in query_components["q"]:
                full_text = json.dumps(list(general_rule_dictionary.values()))
            else:
                full_text = "ToDo: Handle 400 Error"

            self.wfile.write(full_text.encode("utf8"))

    def do_HEAD(self):
        self._set_headers()

    def do_POST(self):
        self._set_headers()

        query_path = urlparse(self.path).query
        query_components = parse_qs(query_path)

        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)

        fields = parse_qs(post_data.decode("utf8"), True)
        full_text = ""

        if "action" in query_components:
            if "insert" in query_components["action"]:
                if "id" in fields and "artery" in fields and "rule_type" in fields:
                    id = int(fields["id"][0])
                    artery = fields["artery"][0]

                    if any(confidence_rule for confidence_rule in self._confidence_rules
                           if confidence_rule.get_id() == id and confidence_rule.get_name() == artery):
                        error = "ToDo: Handle <already exists> Error"
                        return

                    rule_type = fields["rule_type"][0]

                    if rule_type == "general" and "text" in fields:
                        text = fields["text"][0]

                        confidence_rule = ConfidenceRule(id, artery)
                        confidence_rule.set_rule(General(text, artery))

                        self._confidence_rules.append(confidence_rule)

                        full_text += confidence_rule.to_json()
                    elif rule_type == "comparator" and "type" in fields and "mode" in fields and "offset1" in fields and "artery2" in fields and "offset2" in fields:
                        type = fields["type"][0]

                        if type == "cog_x":
                            type = ComparatorType.Cog_X
                        elif type == "cog_z":
                            type = ComparatorType.Cog_Z
                        else:
                            type = ComparatorType.Heigth

                        mode = ComparatorMode.Greater if ["mode"][0] == "greater" else ComparatorMode.Less

                        offset1 = fields["offset1"][0]

                        artery2 = fields["artery2"][0]
                        offset2 = fields["offset2"][0]

                        confidence_rule = ConfidenceRule(id, artery)
                        confidence_rule.set_rule(Comparator(type, mode, artery,
                                                            offset1, artery2, offset2))

                        self._confidence_rules.append(confidence_rule)

                        full_text += confidence_rule.to_json()
                    elif rule_type == "edge" and "artery2" in fields and "is_transitive" in fields:
                        artery2 = fields["artery2"][0]
                        is_transitive = True if fields["is_transitive"][0] == "true" else False

                        confidence_rule = ConfidenceRule(id, artery)
                        confidence_rule.set_rule(Edge(artery, artery2, is_transitive))

                        self._confidence_rules.append(confidence_rule)

                        full_text += confidence_rule.to_json()

                self._log("[INSERT]: " + confidence_rule.to_rule())
            elif "delete" in query_components["action"]:
                if "id" in fields and "name" in fields:
                    id = int(fields["id"][0])
                    artery = fields["name"][0]

                    confidence_rule = next((confidence_rule for confidence_rule in self._confidence_rules
                                            if confidence_rule.get_id() == id and confidence_rule.get_name() == artery), None)

                    if confidence_rule != None:
                        self._confidence_rules.remove(confidence_rule)

                        full_text += "ok"

                        self._log("[DELETED]: " + confidence_rule.to_rule())
                    else:
                        full_text += "ko"

        self.wfile.write(full_text.encode("utf8"))

        main.save_confidence_rules("confidence_rules.db", self._confidence_rules)


class Server:
    def __init__(self, ip: str, port: int, confidence_rules: list):
        self._httpd = HTTPServer((ip, port), ServerHandler)

        self._httpd.RequestHandlerClass.set_c_rules(self._httpd.RequestHandlerClass, confidence_rules)

    def run(self):
        try:
            self._httpd.serve_forever()
        except KeyboardInterrupt:
            pass

        self._httpd.server_close()
