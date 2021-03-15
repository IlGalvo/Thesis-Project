# Simple http server to handle requests from applications
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
import os
from threading import Lock
from json import (
    dumps,
    loads
)
from typing import List
from urllib.parse import (
    urlparse,
    parse_qs
)

from models import (
    Edge,
    Comparator, ComparatorType, ComparatorMode,
    General, general_rule_dictionary,
    ConfidenceRule,
    artery_list
)
from utilities import save_confidence_rules


# Server handler
class _ServerHandler(BaseHTTPRequestHandler):
    # Sets internal data
    def initialize(self, confidence_rules: List[ConfidenceRule], database_file_name: str):
        self._confidence_rules = confidence_rules
        self._database_file_name = database_file_name

        # Server directory must alredy exists!
        self._log_file_name = os.path.dirname(database_file_name)
        self._log_file_name += "/server.log"

        # To handle threadsafe operations
        self._lock = Lock()

    # Converts list of confidence rule to json
    def __confidence_rules_to_json(self) -> str:
        text = "["

        for i in range(0, len(self._confidence_rules)):
            text += self._confidence_rules[i].to_json()

            if i < len(self._confidence_rules) - 1:
                text += ", "

        return text + "]"

    # Generates next valid id for confidence rule name
    def __get_next_id(self, name: str) -> int:
        # Filter for name
        iterator = filter((lambda cr: cr.get_name() == name),
                          self._confidence_rules)
        # Gets max id o None
        confidence_rule = max(iterator, default=None,
                              key=(lambda cr: cr.get_id()))

        # Next valid id
        return confidence_rule.get_id() + 1 if confidence_rule != None else 0

    # Sets ok headers response
    def __send_ok_headers(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()

    # Sets ko headers response
    def __send_ko_headers(self):
        self.send_response(400)
        self.send_header("Content-type", "text/plain")
        self.end_headers()

    # Sends ok response text
    def __send_ok_response(self, text: str):
        self.__send_ok_headers()

        self.wfile.write(text.encode("utf8"))

    # Sends ko response text
    def __send_ko_response(self, text: str):
        self.__send_ko_headers()

        self.wfile.write(text.encode("utf8"))

    # Internal log
    def __log(self, text: str):
        with open(self._log_file_name, "a+") as file:
            file.write(text + "\n")

    # Action when confidence rule is successfully added
    def __handle_added(self, confidence_rule: ConfidenceRule):
        self._confidence_rules.append(confidence_rule)

        text = confidence_rule.to_json()
        self.__send_ok_response(text)

        self.__log("[INSERT]: " + confidence_rule.to_rule())
        save_confidence_rules(self._database_file_name, self._confidence_rules)

    # Action when confidence rule is successfully removed
    def __handle_removed(self, confidence_rule: ConfidenceRule):
        self._confidence_rules.remove(confidence_rule)

        self.__send_ok_headers()

        self.__log("[DELETED]: " + confidence_rule.to_rule())
        save_confidence_rules(self._database_file_name, self._confidence_rules)

    # Handles get requests
    def do_GET(self):
        # Gets request parameters as dictionary
        query_path = urlparse(self.path).query
        query_components = parse_qs(query_path, True)

        # Expected 'q=name'
        if "q" in query_components:
            # Sends confidence rules
            if "confidence_rules" in query_components["q"]:
                # Critical operations on confidence rules
                with self._lock:
                    text = self.__confidence_rules_to_json()
                    self.__send_ok_response(text)
            # Sends artery list
            elif "arteries" in query_components["q"]:
                text = dumps(artery_list)
                self.__send_ok_response(text)
            # Sends general texts
            elif "general_texts" in query_components["q"]:
                text = dumps(list(general_rule_dictionary.values()))
                self.__send_ok_response(text)
            # Sends comparator types
            elif "comparator_types" in query_components["q"]:
                text = dumps([ctype.name for ctype in ComparatorType])
                self.__send_ok_response(text)
            # Sends comparator modes
            elif "comparator_modes" in query_components["q"]:
                text = dumps([cmode.name for cmode in ComparatorMode])
                self.__send_ok_response(text)
            # Fallback query value
            else:
                text = "Wrong query value."
                self.__send_ko_response(text)
        # Fallback query parameter
        else:
            text = "Missing query parameter."
            self.__send_ko_response(text)

    # Handles head requests
    def do_HEAD(self):
        self.__send_ok_headers()

    # Handles post requests
    def do_POST(self):
        # Gets request parameters as dictionary
        query_path = urlparse(self.path).query
        query_components = parse_qs(query_path, True)

        # Reads posted data
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)

        # Gets posted data parameters as dictionary
        post_fields = parse_qs(post_data.decode("utf8"), True)

        # Expected 'action=name'
        if "action" in query_components:
            # Handles insert
            if "insert" in query_components["action"]:
                # Expected main parameters
                if "main_artery" in post_fields and "rule_type" in post_fields:
                    main_artery = post_fields["main_artery"][0]
                    rule_type = post_fields["rule_type"][0]

                    # Critical operations on confidence rules
                    with self._lock:
                        id = self.__get_next_id(main_artery)

                        # Expected valid edge rule data
                        if rule_type == "edge" and "artery" in post_fields and "is_transitive" in post_fields:
                            artery = post_fields["artery"][0]

                            # Converts to bool
                            is_transitive = post_fields["is_transitive"][0]
                            is_transitive = loads(is_transitive.lower())

                            confidence_rule = ConfidenceRule(id, main_artery)

                            # Handles aorta case
                            if artery == "aorta":
                                edge = Edge(artery, main_artery, is_transitive)
                                confidence_rule.set_rule(edge)
                            else:
                                edge = Edge(main_artery, artery, is_transitive)
                                confidence_rule.set_rule(edge)

                            self.__handle_added(confidence_rule)
                        # Expected valid comparator rule data
                        elif rule_type == "comparator" and "type" in post_fields and "mode" in post_fields and \
                                "offset1" in post_fields and "artery" in post_fields and "offset2" in post_fields:
                            # Gets the type
                            type = post_fields["type"][0]
                            type = ComparatorType[type]

                            # Gets the mode
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

                            self.__handle_added(confidence_rule)
                        # Expected valid general rule data
                        elif rule_type == "general" and "text" in post_fields:
                            text = post_fields["text"][0]

                            confidence_rule = ConfidenceRule(id, main_artery)

                            general = General(text, main_artery)
                            confidence_rule.set_rule(general)

                            self.__handle_added(confidence_rule)
                        # Fallback rule_type and value
                        else:
                            text = "Wrong rule_type and values."
                            self.__send_ko_response(text)
                # Fallback main_artery or rule_type
                else:
                    text = "Missing main_artery or rule_type."
                    self.__send_ko_response(text)
            # Handles delete
            elif "delete" in query_components["action"]:
                # Expected id and name
                if "id" in post_fields and "name" in post_fields:
                    id = int(post_fields["id"][0])
                    name = post_fields["name"][0]

                    # Critical operations on confidence rules
                    with self._lock:
                        confidence_rule = next((cr for cr in self._confidence_rules
                                                if cr.get_id() == id and cr.get_name() == name), None)

                        if confidence_rule != None:
                            self.__handle_removed(confidence_rule)
                        # Fallback not exists
                        else:
                            text = "Confidence rule does not exists."
                            self.__send_ko_response(text)
                # Fallback id or name
                else:
                    text = "Missing id or name."
                    self.__send_ko_response(text)
            # Fallback query value
            else:
                text = "Wrong query value."
                self.__send_ko_response(text)
        # Fallback query parameter
        else:
            text = "Missing query parameter."
            self.__send_ko_response(text)


# Simple multithreading http server
class HttpServer:
    def __init__(self, ip: str, port: int, confidence_rules: List[ConfidenceRule], database_file_name: str):
        self._http_server = ThreadingHTTPServer((ip, port), _ServerHandler)

        # Gets handler instance and initialization
        handler = self._http_server.RequestHandlerClass
        handler.initialize(handler, confidence_rules, database_file_name)

    # Runs until Ctrl+C pressed
    def run(self):
        try:
            self._http_server.serve_forever()
        except KeyboardInterrupt:
            pass

        self._http_server.server_close()
