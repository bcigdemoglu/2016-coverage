import numpy as np
from sklearn.ensemble import RandomForestClassifier
from . import app
import googleMapsClient as google
from operator import itemgetter
#Random Forest Classifier
'''
t_f = time to reach to current event from previous event
t_n = time to reach to next event from current event
d_f = distance from previous event
d_n = distance to next event
r_y = yelp global rating for a place
r_u = user average rating for a place
dur = user duration / selected duration
'''
class ML:
  def __init__(self):
    self.RFC = RandomForestClassifier(n_estimators=100, max_depth=15)
    x_train = np.array([
                        [0, 0, 0, 0, 5, 5],
                        [0, 0, 0, 0, 0, 0]
                       ])
    y_train = np.array([1, 0])
    self.RFC.fit(x_train, y_train)

  def updateModel(self, choice, suggestionId):
    '''
    app.mongo.db.suggestions structure:
    {
      uid: suggestionId,
      sugs:
        [
          [t_f, t_n, d_f, d_n, r_y, r_u],
          [t_f, t_n, d_f, d_n, r_y, r_u],
          [t_f, t_n, d_f, d_n, r_y, r_u]
        ]
      yelpId:
        [
          id0,
          id1,
          id2
        ]
    }
    '''

    '''
    app.mongo.db.rfctrainers element structure:
    {
      val: [t_f, t_n, d_f, d_n, r_y, r_u]
    }
    '''

    '''
    app.mongo.db.rfcchoices element structure:
    {
      val: 0 or 1
    }
    '''

    '''
    app.mongo.db.yelp element structure:
    {
      uid: yelpid,
      ratings: [ ratings ]
    }
    '''
    suggestion_data = app.mongo.db.suggestions.find_one({'uid': suggestionId})
    sugs = suggestion_data['sugs']
    for i in range(len(sugs)):
      # Duration would be added here
      app.mongo.db.rfctrainers.insert({'val': sugs[i]})

      # Insert selected y=1
      if int(choice) == i:
        app.mongo.db.rfcchoices.insert({'val': 1})
      # Not selected y=0
      else:
        app.mongo.db.rfcchoices.insert({'val': 0})

    # with open('log_tests', 'w') as file_:
    #     file_.write(str(list(app.mongo.db.rfctrainers.find())))
    #     file_.write("\n\n\n")
    #     file_.write(str(list(app.mongo.db.rfcchoices.find())))

    xl_trainers = list(app.mongo.db.rfctrainers.find({}, {'_id': False}))
    yl_choices = list(app.mongo.db.rfcchoices.find({}, {'_id': False}))

    # Pluck 'val' keys to create nd.arrays
    x_train = np.array([d['val'] for d in xl_trainers])
    y_train = np.array([d['val'] for d in yl_choices])

    self.RFC.fit(x_train, y_train)

  def pickSuggestions(self, businessList, all_suggestions):
    '''
    all_suggestions =
      [
        [t_f, t_n, d_f, d_n, r_y, r_u],
        ...
      ]
    )
    '''
    # Get predictions for business data
    sugs = np.array(all_suggestions)
    rfc_probs = np.array([e[0] for e in np.array(self.RFC.predict_proba(sugs))])
    # Find location of max probs
    max_probs = rfc_probs.argsort()[-3:][::-1]
    # Get max probs in np.array type
    top_probs = (rfc_probs[max_probs]).tolist()
    # Get best vectors
    top_sugs = sugs[max_probs].tolist()
    # Get best business corresponding to max probs in np.array type
    top_biz = (np.array(businessList)[max_probs]).tolist()
    yelp_ids = [d['id'] for d in top_biz]
    return {'business': top_biz,
            'probs': top_probs,
            'sugs': top_sugs,
            'ids': yelp_ids}

  def getSuggestionArray(self, yelp, yelpId, prev_event, next_event):
    # Initialize defaults
    t_f, t_n, d_f, d_n, r_y, r_u = 0, 0, 0, 0, 0, 0
    curr = yelp.getBusiness(yelpId)
    r_y = curr['rating']
    # Get user ratings
    userrating = app.mongo.db.yelp.find_one({'uid': yelpId}, {'_id': False})
    if userrating is not None:
      r_u = sum(userrating["ratings"])/len(userrating["ratings"])
    # Get previous event data
    if prev_event is not None and prev_event.get('yelpId'):
      prev_yelp = prev_event.get('yelpId')
      prev_coords = yelp.getBusiness(prev_yelp)['coord']
      prev_google = google.getInfo(prev_coords, curr['coord'])
      t_f = prev_google['dur']
      d_f = prev_google['dist']
    # Get next event data
    if next_event is not None and next_event.get('yelpId'):
      next_yelp = next_event.get('yelpId')
      next_coords = yelp.getBusiness(next_yelp)['coord']
      next_google = google.getInfo(curr['coord'], next_coords)
      t_n = next_google['dur']
      d_n = next_google['dist']
    return [t_f, t_n, d_f, d_n, r_y, r_u]

  @staticmethod
  def getPrevAndNextEvent(events, event):
    prev_event, next_event = None, None
    events_sorted = sorted(events, key=itemgetter('start'))
    event_ind = next(index for (index, d) in enumerate(events_sorted) if d['start'] == event['start'])
    if event_ind > 0:
      prev_event = events_sorted[event_ind - 1]
    if event_ind < len(events_sorted) - 1:
      next_event = events_sorted[event_ind + 1]
    return [prev_event, next_event]


classifier = ML()