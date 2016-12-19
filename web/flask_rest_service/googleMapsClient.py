import requests

# orig_coord = "39.3279694, -76.6336234"
# dest_coord = "39.323654, -76.631761"
def getInfo(orig_coord, dest_coord):
  params = "origins={0}&destinations={1}&mode=drive".format(str(orig_coord),str(dest_coord))
  url = "https://maps.googleapis.com/maps/api/distancematrix/json?" + params
  info = requests.get(url).json()["rows"][0]["elements"][0]
  return {'dur': info["duration"]['value'],
          'dist': info["distance"]['value']}
