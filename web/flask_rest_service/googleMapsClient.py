import requests

# orig_coord = "39.3279694, -76.6336234"
# dest_coord = "39.323654, -76.631761"
def getDist(orig_long, orig_lat, dest_long, dest_lat):
  orig_coord = str(orig_long) + ", " + str(orig_lat)
  dest_coord = str(dest_long) + ", " + str(dest_lat)
  params = "origins={0}&destinations={1}&mode=drive".format(str(orig_coord),str(dest_coord))
  url = "https://maps.googleapis.com/maps/api/distancematrix/json?" + params
  requests.get(url).json()["rows"][0]["elements"][0]["duration"]['value']
