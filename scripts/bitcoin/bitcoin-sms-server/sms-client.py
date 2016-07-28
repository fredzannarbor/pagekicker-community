#!/usr/bin/env python3
import urllib.parse

from two1.wallet import Wallet
from two1.bitrequests import BitTransferRequests

wallet = Wallet()
requests = BitTransferRequests(wallet)


# request the bitcoin-enabled endpoint that you're hosting
def testendpoint(sms='I just paid you bitcoin to send you this message!'):
    # In a real application you would escape this message to prevent injections
    message = urllib.parse.quote_plus(sms)
    response = requests.get(url='http://localhost:5000/send-sms?text='+message)
    print(response.text)

if __name__ == '__main__':
    import sys
    testendpoint(sys.argv[1])
