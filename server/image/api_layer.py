from flask_restful import Resource
import json
import os
from subprocess import run

from data_layer import *

session_mgr = SessionManager()
error_mgr = ErrorManager()

class OpenSession(Resource):
    def get(self):
        session_id = session_mgr.open()
        return error_mgr.ok(session_id)

class CloseSession(Resource):
    def get(self, session_id):
        r = session_mgr.close(session_id)
        if r:
            return error_mgr.ok()
        else:
            return error_mgr.no_session()

class UploadData(Resource):
    def get(self, session_id, data):
        if session_mgr.is_ok(session_id):
            # Parse data as JSON
            data = json.loads(data)

            try:
                # Open data file for this user
                with open("data_dir/%d/data.json" % session_id, 'a') as file:
                    # Write JSON in compact form
                    file.write("%s\n" % json.dumps(data))

            except Exception as e:
                session_mgr.close(session_id)
                return error_mgr.exception(e)

            # Return "ok" to the user
            return error_mgr.ok()
        else:
            return error_mgr.no_session()

class Propose(Resource):
    def get(self, session_id):
        if session_mgr.is_ok(session_id):
            try:
                # Call the mlrMBO R script to actually propose a point.
                c = run(["Rscript", "propose.R", str(session_id)])
                c.check_returncode()
                point = c.stdout

            except Exception as e:
                session_mgr.close(session_id)
                return error_mgr.exception(e)
            return point, 200
        else:
            return error_mgr.no_session()
