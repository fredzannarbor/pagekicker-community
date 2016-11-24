# -*- coding: utf-8 -*-
"""
Created on Wed Sep  7 18:44:35 2016

@author: fred
"""
import subprocess
import os
import psutil
import json
import shlex
import configparser

from flask import Flask, request, send_from_directory
from werkzeug.utils import secure_filename

import logging
from logging import FileHandler



config = configparser.ConfigParser()
config.read("config.ini")
commandpath = config.get("Paths", "commandpath")
mycwd = config.get("Paths", "mycwd")


# Configure the app
app = Flask(__name__)

file_handler = FileHandler("/tmp/pagekicker/debug.log","a")
file_handler.setLevel(logging.WARNING)
app.logger.addHandler(file_handler)

UPLOAD_FOLDER = '/tmp/pagekicker/'
ALLOWED_EXTENSIONS = set(['json'])

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

@app.route('/api-json', methods=['GET', 'POST'])

def upload_file():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            print('No file part')
            return
        file = request.files['file']
        # if user does not select file, browser also
        # submit a empty part without filename
        if file.filename == '':
            print('No selected file')
            return
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            filename = str((os.path.join(app.config['UPLOAD_FOLDER'], filename)))
            with open(filename) as json_data:
                d = json.load(json_data)
                s = ' '.join( '{} "{}"'.format(k, v) for k,v in d['options'].items() )

        cli = commandpath + ' ' + s
        print('command line will be' + ' ' + cli)
        args = shlex.split(cli)
        print(args)
        status = subprocess.check_output(args, cwd = mycwd)
        return send_from_directory('/tmp/pagekicker/', '4stdout.txt')

# Initialize and run the server
if __name__ == '__main__':

   import click

   @click.command()
   @click.option("-d", "--daemon", default=False, is_flag=True,
                  help="Run in daemon mode.")

   def run(daemon):
            if daemon:
                pid_file = './api-json.pid'
                if os.path.isfile(pid_file):
                    pid = int(open(pid_file).read())
                    os.remove(pid_file)
                    try:
                        p = psutil.Process(pid)
                        p.terminate()
                    except:
                        pass
                try:
                    p = subprocess.Popen(['python3', 'api-json.py'])
                    open(pid_file, 'w').write(str(p.pid))
                except subprocess.CalledProcessError:
                    raise ValueError("error starting api-json.py daemon")
            else:
                print("api-json running...")
                app.run(host='::', port=5036, debug=True)
   run()
