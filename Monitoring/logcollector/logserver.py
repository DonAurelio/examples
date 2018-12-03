# -*- coding: utf-8 -*-

"""
Autor: Aurelio Vivas <aa.vivas@uniandes.edu.co>
Name: logserver
This Flag application serves the logs generated on this computer throught API endpoints. 
"""

# RUNNING THE APPLICATION
# To run the application you can either use the flask command or python’s -m switch with Flask. 
# Before you can do that you need to tell your terminal the application to work with by exporting
# the FLASK_APP environment variable:
# export FLASK_APP=${PWD}/logserver.py
# flask run --host=0.0.0.0:5000
# flask run -h 0.0.0.0 -p 5000
# * Running on http://127.0.0.1:5000/

from flask import Flask
import os


# An instance of this class will be our WSGI application
app = Flask(__name__)


OUT_LOG_FILE_PATH = 'out.log'
ERR_LOG_FILE_PATH = 'err.log'


@app.route('/log/out',methods=['GET'])
def send_out_logs():
    with open(OUT_LOG_FILE_PATH,'r') as file:
        text = file.read()
        return text, 200

@app.route('/log/err',methods=['GET'])
def send_err_log():
    with open(OUT_LOG_FILE_PATH,'r') as file:
        text = file.read()
        return text, 200

@app.route('/log/out/clean',methods=['POST'])
def clean_out_log():
    if os.path.exists(OUT_LOG_FILE_PATH):
        os.remove(OUT_LOG_FILE_PATH)
        message = 'file ' + OUT_LOG_FILE_PATH + ' was removed successfully !'
        return message, 200
    message = 'file ' + OUT_LOG_FILE_PATH + ' does not exist !'
    return message, 400

@app.route('/log/err/clean',methods=['POST'])
def clean_err_log():
    if os.path.exists(ERR_LOG_FILE_PATH):
        os.remove(ERR_LOG_FILE_PATH)
        message = 'file ' + ERR_LOG_FILE_PATH + ' was removed successfully !'
        return message, 200
    message = 'file ' + ERR_LOG_FILE_PATH + ' does not exist !'
    return message, 400
