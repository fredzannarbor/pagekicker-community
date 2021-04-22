#!/usr/bin/env python3

from two1.wallet import Wallet
from two1.bitrequests import BitTransferRequests

# set up bitrequest client for BitTransfer requests
wallet = Wallet()
requests = BitTransferRequests(wallet)

# server address
server_url = 'http://localhost:5000/'

def buy_fortune():

   url = server_url+'buy?payout_address={0}'
   response = requests.get(url=url.format(wallet.get_payout_address()))
   print(response.text)
              
if __name__ == '__main__':
    buy_fortune()
