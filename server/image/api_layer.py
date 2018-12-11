from flask_restful import Resource
import json
import os
from subprocess import run, PIPE
import pyRserve

from data_layer import *

session_mgr = SessionManager()
error_mgr = ErrorManager()
data_mgr = DataManager()

# This creates a new session and returns the session id.
class OpenSession(Resource):
    def get(self):
        session_id = session_mgr.open()
        return error_mgr.ok(session_id)

# This finalizes a session and removes all data on the server stored for it.
class CloseSession(Resource):
    def get(self, session_id):
        r = session_mgr.close(session_id)
        if r:
            return error_mgr.ok()
        else:
            return error_mgr.no_session()
            
# This changes the mbo-configuration for a session.
class Set(Resource):
    def get(self, session_id, key, value):
        if session_mgr.is_ok(session_id):
            # TODO: Check, if a first proposal has been made.
            #       If so, disallow this endpoint and return an error.
            
            if data_mgr.is_key_valid(key):
                if data_mgr.is_value_valid(key, value):
                    data_mgr.set_kv(session_id, key, value)
                    # Return "ok" to the user
                    return error_mgr.ok()
                else:
                    return error_mgr.invalid_value(key)
            else:
                return error_mgr.invalid_key()
        else:
            return error_mgr.no_session()

# This appends data to the mbo-model for this session.
class UploadData(Resource):
    def get(self, session_id, data):
        if session_mgr.is_ok(session_id):
            try:
                # Parse data as JSON
                data = json.loads(data)

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

# This proposes a point for the given session.
class Propose(Resource):
    def get(self, session_id):
        if session_mgr.is_ok(session_id):
            try:
                # Call the mlrMBO R script to actually propose a point.
                conn = pyRserve.connect()
                conn.eval('setwd("..")')
                
                # Prepare call in R
                commandline = 'propose("%s")' % str(session_id)

                # Run that function
                point = conn.eval(commandline)
                
                # Close connection
                conn.close()
                
                # Debugging
                point = json.loads(point)

            except Exception as e:
                print(e)
                session_mgr.close(session_id)
                return error_mgr.internal_error()
            return point, 200
        else:
            return error_mgr.no_session()
