import os
from yelp.client import Client
from yelp.oauth1_authenticator import Oauth1Authenticator

''' API info: https://github.com/Yelp/yelp-python '''
auth = Oauth1Authenticator(
  consumer_key=os.environ.get('YELP_CONSUMER_KEY'),
  consumer_secret=os.environ.get('YELP_CONSUMER_SECRET'),
  token=os.environ.get('YELP_TOKEN'),
  token_secret=os.environ.get('YELP_TOKEN_SECRET')
)
client = Client(auth)
