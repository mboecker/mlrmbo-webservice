import random
import shutil
import os

class SessionManager:
    # This set contains the current session_ids
    sessions = set()

    def open(self):
        # Generate random session id
        session_id = random.randrange(100000, 999999)
        self.sessions.add(session_id)

        # Create data directory for this session
        os.makedirs("data_dir/%d" % session_id)
        return session_id

    def close(self, session_id):
        if self.is_ok(session_id):
            # Remove data file and session directory
            filename = "data_dir/%d" % session_id
            if os.path.isdir(filename):
                shutil.rmtree(filename)
            self.sessions.remove(session_id)
            return True
        else:
            return False

    def is_ok(self, session_id):
        return session_id in self.sessions

class ErrorManager:
    def ok(self, msg = "ok"):
        return msg, 200

    def no_session(self):
        return "no such session", 500

    def exception(self, e):
        return "exception: %s" % e, 500
