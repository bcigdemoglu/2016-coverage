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

  def getBusinessList(self, query, num):
    if self.client is None: return []
    bizList = []
    yelp_data = self.client.search(query).businesses
    limit = num if len(yelp_data) > num else len(yelp_data)
    for i in range(limit):
      biz = self.getBizObj(yelp_data[i].__dict__)
      bizList.append(biz)
    return bizList

  def getBusiness(self, biz_id):
    return self.getBizObj(self.client.get_business(biz_id).business.__dict__)

  @staticmethod
  def getBizObj(biz):
    biz_lat = str(biz['location'].coordinate.latitude)
    biz_long = str(biz['location'].coordinate.longitude)
    biz['coord'] = biz_lat + ", " + biz_long
    return {'id':     biz['id'],
            'rating': biz['rating'],
            'name':   biz['name'],
            'coord':  biz['coord'],
            'display_address': biz['location'].display_address}

client = YelpClient()
