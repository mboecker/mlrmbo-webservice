from flask import Flask
from flask_restful import Api, Resource, reqparse
from time import sleep
import shutil
import os

from api_layer import *

if os.path.isdir("data_dir"):
    shutil.rmtree("data_dir")

app = Flask(__name__)
api = Api(app)

api.add_resource(OpenSession, "/session/open")
api.add_resource(CloseSession, "/session/close/<int:session_id>")
api.add_resource(UploadData, "/upload/<int:session_id>/<data>")
api.add_resource(Propose, "/propose/<int:session_id>")

if __name__ == '__main__':
    app.run(host = "0.0.0.0", debug = True)
