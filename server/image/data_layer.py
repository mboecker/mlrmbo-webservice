import random
import shutil
import os
import uuid
import json
from subprocess import run, PIPE

class SessionManager:
    # This set contains the current session_ids
    sessions = set()

    def open(self):
        # Generate random session id
        session_id = uuid.uuid4().int
        self.sessions.add(session_id)

        # Create data directory for this session
        os.makedirs("data_dir/%d" % session_id)
        
        # Create default mlrMBO configuration
        c = run(["Rscript", "setup.R", str(session_id)], encoding = "ascii", stdout = PIPE)
        c.check_returncode()
        
        return session_id

    def close(self, session_id):
        if self.is_ok(session_id):
            # Remove data file and session directory
            filename = "data_dir/%d" % session_id
#           if os.path.isdir(filename):
#               shutil.rmtree(filename)
            self.sessions.remove(session_id)
            return True
        else:
            return False

    def is_ok(self, session_id):
        return session_id in self.sessions

class ErrorManager:
    def ok(self, msg = "ok"):
        return msg, 200
        
    def error(self, msg):
        return "error: %s" % msg, 500
        
    def invalid_key(self):
        return self.error("invalid key")
        
    def invalid_value(self, key):
        return self.error("invalid value for key %s" % key)

    def no_session(self):
        return self.error("no such session")

    def internal_error(self):
        return self.error("there was an error while working on your request")

    def exception(self, e):
        return self.error("exception: %s" % e)

class DataManager:
    def boolean_keys(self):
        return ["noisy", "minimize"]
        
    def numeric_keys(self):
        return ["propose.points", "opt.restarts", "opt.focussearch.maxit", "opt.focussearch.points"]
    
    def string_keys(self):
        # learner key: one can only set the name of the learner currently
        # crit key should be either "EI" or "CB"
        # opt can be either focussearch, "cmaes" or "nsga2"
        return ["learner", "crit", "opt"]
    
    def valid_keys(self): 
        # design key should be used by data.json
        return set(["par.set"]).union(self.numeric_keys()).union(self.boolean_keys()).union(self.string_keys())
    
    def is_key_valid(self, key):
        return key in self.valid_keys()

    def is_value_valid(self, key, value):
        # Check if the value is valid for the key
        if key in self.boolean_keys():
            return value in ["true","false"]
        if key in self.numeric_keys():
            try:
                int(value)
                return True
            except e:
                return False
        return True

    def set_kv(self, session_id, key, value):
        # Assumes that key and value are valid
        with open("data_dir/%s/config.json" % session_id, "r+") as config_file:
            # Read json file
            data = json.load(config_file)
            
            # Replace or append key-value
            data[key] = value
            
            # Place file cursor at start of file in order to overwrite old config
            config_file.seek(0)
            
            # Write json back to file
            json.dump(data, config_file)
