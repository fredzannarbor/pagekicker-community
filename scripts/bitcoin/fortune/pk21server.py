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

    fortune = subprocess.check_output(["fortune"])
    return print(fortune)

if __name__ == '__main__':
    app.run(host='0.0.0.0')
