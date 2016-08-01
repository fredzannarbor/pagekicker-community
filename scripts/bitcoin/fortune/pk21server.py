#!/usr/bin/env python3

import subprocess

from flask import Flask


from two1.wallet import Wallet
from two1.bitserv.flask import Payment

app = Flask(__name__)
wallet = Wallet()
payment = Payment(app, wallet)

# machine-payable endpoint that returns fortune if payment made
@app.route('/buy')
@payment.required(1000)
def buy_fortune():

    fortune = subprocess.check_output(['fortune', 'potterfacts'])
    return fortune
    
@app.route('/manifest')
def docs():
    '''
    Serves the app manifest to the 21 crawler.
    '''
    with open('manifest.yaml', 'r') as f:
        manifest_yaml = yaml.load(f)
    return json.dumps(manifest_yaml)

if __name__ == '__main__':
    app.run(host='0.0.0.0')
