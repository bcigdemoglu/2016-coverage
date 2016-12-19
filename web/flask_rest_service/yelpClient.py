import os
from yelp.client import Client
from yelp.oauth1_authenticator import Oauth1Authenticator

''' API info: https://github.com/Yelp/yelp-python '''
class YelpClient:
  def __init__(self):
    self.client = None
    if os.environ.get('YELP_CONSUMER_KEY') is not None:
      auth = Oauth1Authenticator(
        consumer_key=os.environ.get('YELP_CONSUMER_KEY'),
        consumer_secret=os.environ.get('YELP_CONSUMER_SECRET'),
        token=os.environ.get('YELP_TOKEN'),
        token_secret=os.environ.get('YELP_TOKEN_SECRET')
      )
      self.client = Client(auth)

  def getBusinessInfo(self, query, num):
    if self.client is None: return []
    bizList = []
    for i in range(num):
      biz = self.client.search(query).businesses[i].__dict__
      biz_lat = str(biz['location'].coordinate.latitude)
      biz_long = str(biz['location'].coordinate.longitude)
      biz['coord'] = biz_lat + ", " + biz_long
      bizList.append({'id':     biz['id'],
                      'rating': biz['rating'],
                      'name':   biz['name'],
                      'coord':  biz['coord']})
    return bizList

client = YelpClient()
