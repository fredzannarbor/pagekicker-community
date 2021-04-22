#!/usr/bin/env python3
import os

from twilio.rest import TwilioRestClient
from flask import Flask, request

from two1.wallet import Wallet
from two1.bitserv.flask import Payment

app = Flask(__name__)
wallet = Wallet()
payment = Payment(app, wallet)

# create the twilio rest client
client = TwilioRestClient(
    os.environ.get('TWILIO_ACCOUNT_SID'),
    os.environ.get('TWILIO_AUTH_TOKEN')
)


@app.route('/send-sms')
@payment.required(3000)
def send_sms():
    """Send an sms for bitcoin"""
    text = request.args.get('text')
    client.messages.create(
        to=os.environ.get('MY_PHONE_NUMBER'),
        from_=os.environ.get('TWILIO_PHONE_NUMBER'),
        body=text
    )
    return "Message sent."

# set up and run the server
if __name__ == '__main__':
    app.run(host='0.0.0.0')
