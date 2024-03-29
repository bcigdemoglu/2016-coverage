#!/usr/bin/python
"""
    Flaskr Tests
    ~~~~~~~~~~~~
    Tests the Flaskr application
"""
import os
from pymongo import MongoClient
import unittest
from .. import app
from flask import json

class PlanItTestCase(unittest.TestCase):
    json_header = {'Content-Type' : 'application/json'}
    '''
    Pretty print json data
    '''
    # def pprint(data, indent=2):
    #     print(json.dumps(json.loads(data), indent=indent))

    def json_post(self, handler, raw_dict):
        return self.app.post(handler, data=json.dumps(raw_dict), headers=self.json_header)

    def json_get(self, handler, raw_dict):
        return self.app.get(handler, data=json.dumps(raw_dict), headers=self.json_header)

    def json_delete(self, handler, raw_dict):
        return self.app.delete(handler, data=json.dumps(raw_dict), headers=self.json_header)

    '''
    db.users
        usernames: alex, naina, amy, bugi
        passwords: <username> + "123"

    db.itin
        itineraries:
            createdBy: <username>
            name: itin + <[1-5]>
            uid: <username> + "_" + <itineraries.name>
    '''
    def populate(self):
        self.app.post('/testdb/populatedb', data={})
        self.app.post('/testdb/populateItineraries', data={})

        # Make sure multiples are not added
        self.app.get('/testdb/populatedb', data={})
        self.app.get('/testdb/populateItineraries', data={})

    def setUp(self):
        self.app = app.test_client()
        app.config['TESTING'] = True
        app.config['MONGO_URI'] = "mongodb://localhost:27017/test"
        # with flask_rest_service.app.app_context():
        mongo = MongoClient(app.config['MONGO_URI'])
        db = mongo.test_database
        app.db = mongo
        self.populate()

    def tearDown(self):
        """Get rid of the database again after each test"""
        app.db.drop_database('local')
        app.db.close()

    # def test_getting_object(self):
    #   response = self.app.post('/myobject/',
    #     data=json.dumps(dict(
    #       name="Another object"
    #     )),
    #     content_type = 'application/json')

    #   postResponseJSON = json.loads(response.data.decode())
    #   postedObjectID = postResponseJSON["_id"]

    #   response = self.app.get('/myobject/'+postedObjectID)
    #   responseJSON = json.loads(response.data.decode())

    #   self.assertEqual(response.status_code, 200)
    #   assert 'Another object' in responseJSON["name"]

    # def login(self, username, password):
    #     return self.app.post('/login', data=dict(
    #             username = username,
    #             password = password
    #         ), follow_redirects=True)

    # def logout(self):
    #     return self.app.get('/logout', follow_redirects=True)

    # Testing functions
    def test_home(self):
        """Test root call"""
        rv = self.app.get('/')
        assert 'localhost:27017' in str(rv.data)

    def test_login(self):
        """Test login"""
        rv = self.json_post('/login', dict(
                username = 'alex',
                password = 'alex123'
                ))
        assert 'alex' in str(rv.data)
        assert 'Alex' in str(rv.data)

        rv = self.json_post('/login', dict(
                username = 'alex',
                password = 'alex13'
                ))
        assert 'Incorrect password' in str(rv.data)

        rv = self.json_post('/login', dict(
                username = 'bbbb',
                password = '2312312'
                ))
        assert "Invalid username" in str(rv.data)

    def test_register(self):
        """Test user register"""
        rv = self.json_post('/register', dict(
                username = 'tester',
                password = 'test123',
                name= 'Mr Test'
                ))
        assert 'Mr Test' in str(rv.data)

        rv = self.json_post('/register', dict(
                username = 'tester',
                password = 'test123',
                name= 'Mr Test'
                ))
        assert 'User already exists' in str(rv.data)

    def test_createItinerary(self):
        """Test create itinerary for a user"""
        rv = self.json_post('/createItinerary/alex', dict(
                name = 'New Day',
                date = '2015-08-21T00:00:00.000Z'
                ))
        itinHash = str('alex' + "_" + '2015-08-21T00:00:00.000Z')
        assert itinHash in str(rv.data)

        rv = self.json_post('/createItinerary/alex', dict(
                name = 'New Day',
                date= '2015-08-21T00:00:00.000Z'
                ))
        assert 'Itinerary date already in use' in str(rv.data)

        rv = self.json_post('/createItinerary/bbbb', dict(
                name = 'New Day',
                date= '2015-08-21T00:00:00.000Z'
                ))
        assert 'Invalid username' in str(rv.data)

    def test_getItinerary(self):
        """Test get itinerary for a user"""
        rv = self.app.get('/itinerarylistshells/alex')
        for i in range(5):
            assert "itin"+str(i+1) in str(rv.data)

        rv = self.app.get('/itinerarylistshells/bbbb')
        assert "Invalid username" in str(rv.data)

    def test_createEvent(self):
        """Test create event"""
        invEvent = dict(start = '2015-08-21T12:23:00.000Z',
                        end = '2015-08-21T11:25:00.000Z',
                        date = '2015-08-21T00:00:00.000Z')
        event = dict(start = '2015-08-21T11:23:00.000Z',
                     end = '2015-08-21T11:25:00.000Z',
                     date = '2015-08-21T00:00:00.000Z')
        eventCollide = dict(start = '2015-08-21T11:24:00.000Z',
                            end = '2015-08-21T11:24:30.000Z',
                            date = '2015-08-21T00:00:00.000Z')

        rv = self.json_post('/createEvent/bbbb', event)
        assert 'Invalid username' in str(rv.data)

        rv = self.json_post('/createEvent/alex', invEvent)
        assert 'Invalid date range' in str(rv.data)

        rv = self.json_post('/createEvent/alex', event)
        assert 'Itinerary for the day not found' in str(rv.data)

        # Create sample itinerary for alex for the event day
        self.json_post('/createItinerary/alex', dict(
                name = 'New Day',
                date = '2015-08-21T00:00:00.000Z'
                ))

        rv = self.json_post('/createEvent/alex', event)
        uid = str('alex_' + event['start'] + event['end'])
        assert uid in str(rv.data)

        rv = self.json_post('/createEvent/alex', eventCollide)
        assert 'Collision with another event' in str(rv.data)

        sharedEvent = dict(uid = uid)

        rv = self.json_post('/createEvent/naina', sharedEvent)
        assert 'Itinerary for the day not found' in str(rv.data)

        # Create sample itinerary for naina for the event day
        self.json_post('/createItinerary/naina', dict(
                name = 'New Day',
                date = '2015-08-21T00:00:00.000Z'
                ))

        rv = self.json_post('/createEvent/naina', sharedEvent)
        assert "User is not invited" in str(rv.data)

        # Share event with naina
        rv = self.json_post('/inviteToEvent/alex', dict(
                uid = uid,
                invited = 'naina'
                ))
        assert uid in str(rv.data)

        rv = self.json_post('/createEvent/naina', sharedEvent)
        assert uid in str(rv.data)

    def test_inviteToEvent(self):
        """Test inviting user to event"""
        # Create sample itinerary for alex for the event day
        self.json_post('/createItinerary/alex', dict(
                name = 'New Day',
                date = '2015-08-21T00:00:00.000Z'
                ))
        # Create sample itinerary for naina for the event day
        self.json_post('/createItinerary/naina', dict(
                name = 'New Day1',
                date = '2015-08-21T00:00:00.000Z'
                ))
        # Create sample itinerary for bugi for the event day
        self.json_post('/createItinerary/bugi', dict(
                name = 'New Day',
                date = '2015-08-21T00:00:00.000Z'
                ))
        # Create sample itinerary for amy for the event day
        self.json_post('/createItinerary/amy', dict(
                name = 'New Day',
                date = '2015-08-21T00:00:00.000Z'
                ))

        event = dict(start = '2015-08-21T11:23:00.000Z',
                     end = '2015-08-21T11:25:00.000Z',
                     date = '2015-08-21T00:00:00.000Z')
        rv = self.json_post('/createEvent/alex', event)
        uid = str('alex_' + event['start'] + event['end'])
        assert uid in str(rv.data)

        rv = self.json_post('/inviteToEvent/bbbb', event)
        assert 'Invalid username' in str(rv.data)

        rv = self.json_post('/inviteToEvent/alex', dict(
                uid = "invalidid",
                invited = 'naina'
                ))
        print(rv.data)
        assert "Event not found" in str(rv.data)

        rv = self.json_post('/inviteToEvent/alex', dict(
                uid = uid,
                invited = 'bbbbb'
                ))
        assert "Shared user does not exist" in str(rv.data)

        # Share event with naina
        rv = self.json_post('/inviteToEvent/alex', dict(
                uid = uid,
                invited = 'naina'
                ))
        assert uid in str(rv.data)

        rv = self.json_post('/inviteToEvent/alex', dict(
                uid = uid,
                invited = 'naina'
                ))
        assert "Already sent invitation" in str(rv.data)

        rv = self.json_post('/createEvent/naina', dict(
                uid = uid
                ))
        assert uid in str(rv.data)

        rv = self.json_post('/inviteToEvent/alex', dict(
                uid = uid,
                invited = 'naina'
                ))
        assert "Already shared with user" in str(rv.data)

        # Share event with amy
        rv = self.json_post('/inviteToEvent/alex', dict(
                uid = uid,
                invited = 'amy'
                ))
        assert uid in str(rv.data)

        # Share event with amy
        rv = self.json_post('/inviteToEvent/alex', dict(
                uid = uid,
                invited = 'bugi'
                ))
        assert uid in str(rv.data)

        # Share event with amy
        rv = self.json_post('/inviteToEvent/alex', dict(
                uid = uid,
                invited = 'amy'
                ))
        assert "Already sent invitation" in str(rv.data)

        rv = self.json_post('/createEvent/amy', dict(
                uid = uid
                ))
        print(rv.data)
        assert uid in str(rv.data)

    def test_getEventsForItinerary(self):
        """Test retrieval of events for an itinerary"""
        date = {'date': '2015-08-21T00:00:00.000Z'}
        events = []
        for i in range(10):
            hh = str(i)
            events.append(dict(start = '2015-08-21T'+hh+':23:00.000Z',
                               end = '2015-08-21T'+hh+':25:00.000Z',
                               date = '2015-08-21T00:00:00.000Z'))

        rv = self.json_get('/getEventsForItinerary/bbbb', date)
        assert 'Invalid username' in str(rv.data)

        rv = self.json_get('/getEventsForItinerary/alex', date)
        assert 'Itinerary for the day not found' in str(rv.data)

        # Create sample itinerary for alex for the event day
        self.json_post('/createItinerary/alex', dict(
                name = 'New Day',
                date = date['date']
                ))

        rv = self.json_get('/getEventsForItinerary/alex', date)
        assert '{"events": []}' in str(rv.data)

        for e in events:
            rv = self.json_post('/createEvent/alex', e)
            uid = str('alex_' + e['start'] + e['end'])
            assert uid in str(rv.data)

        rv = self.json_get('/getEventsForItinerary/alex', date)
        for e in events:
            uid = str('alex_' + e['start'] + e['end'])
            assert uid in str(rv.data)
            assert e['start'] in str(rv.data)
            assert e['end'] in str(rv.data)

    def test_getEventsFromId(self):
        """Test retrieval of event data from uid"""
        date = {'date': '2015-08-21T00:00:00.000Z'}
        events = []
        for i in range(10):
            hh = str(i)
            events.append(dict(start = '2015-08-21T'+hh+':23:00.000Z',
                               end = '2015-08-21T'+hh+':25:00.000Z',
                               date = '2015-08-21T00:00:00.000Z'))
        # Create sample itinerary for alex for the event day
        self.json_post('/createItinerary/alex', dict(
                name = 'New Day',
                date = date['date']
                ))

        uid = str('alex_' + events[0]['start'] + events[0]['end'])
        invuid = '00000000000000000000000'

        for e in events:
            rv = self.json_post('/createEvent/alex', e)
            uid = str('alex_' + e['start'] + e['end'])
            assert uid in str(rv.data)

        rv = self.json_get('/getEventFromId/bbbb', {'uid': uid})
        assert 'Invalid username' in str(rv.data)

        rv = self.json_get('/getEventFromId/alex', {'uid': invuid})
        assert 'Event not found' in str(rv.data)

        for e in events:
            uid = str('alex_' + e['start'] + e['end'])
            rv = self.json_get('/getEventFromId/alex', {'uid': uid})
            assert uid in str(rv.data)
            assert e['start'] in str(rv.data)
            assert e['end'] in str(rv.data)

    def test_updateEvent(self):
        """Test suggestions and update event data"""
        date = {'date': '2015-08-21T00:00:00.000Z'}
        eventprev = dict(start = '2015-08-21T01:23:00.000Z',
                         end =   '2015-08-21T01:25:00.000Z',
                         date =  '2015-08-21T00:00:00.000Z')
        eventcurr = dict(start = '2015-08-21T02:23:00.000Z',
                         end =   '2015-08-21T02:25:00.000Z',
                         date =  '2015-08-21T00:00:00.000Z')
        eventnext = dict(start = '2015-08-21T03:23:00.000Z',
                         end =   '2015-08-21T03:25:00.000Z',
                         date =  '2015-08-21T00:00:00.000Z')
        i=0
        # Create sample itinerary for alex for the event day
        self.json_post('/createItinerary/alex', dict(
                name = 'New Day',
                date = date['date']
                ))

        uid = str('alex_' + eventprev['start'] + eventprev['end'])
        uidcurr = str('alex_' + eventcurr['start'] + eventcurr['end'])
        uidnext = str('alex_' + eventnext['start'] + eventnext['end'])
        invuid = '00000000000000000000000'

        rv = self.json_post('/createEvent/alex', eventprev)
        assert uid in str(rv.data)

        rv = self.json_post('/createEvent/alex', eventnext)
        assert uidnext in str(rv.data)

        rv = self.json_post('/createEvent/alex', eventcurr)
        assert uidcurr in str(rv.data)

        rv = self.json_post('/updateEvent/bbbb', {'uid': uid})
        assert 'Invalid username' in str(rv.data)

        rv = self.json_post('/updateEvent/alex', {'uid': invuid})
        assert 'Event not found' in str(rv.data)

        rv = self.json_get('/getSuggestions/bbbb', {'uid': uid,
                                                     'query': 'Homewood Campus, Baltimore'})
        assert 'Invalid username' in str(rv.data)

        rv = self.json_get('/getSuggestions/bbbb', {'uid': uid,
                                                     'query': 'Homewood Campus, Baltimore'})
        assert 'Invalid username' in str(rv.data)

        # Set prev event
        rv = self.json_get('/getSuggestions/alex', {'uid': uid,
                                                    'query': 'Homewood Campus, Baltimore'})
        sugId = json.loads(rv.data)['uid']
        placeId = json.loads(rv.data)['business'][1]['id']
        assert 'business' in str(rv.data)

        rv = self.json_post('/updateEvent/alex', {'uid': uid,
                                                  'choice': '1',
                                                  'suggestionId': sugId})
        assert 'yelpId' in str(rv.data)

        rv = self.json_post('/ratePlace/alex', {'uid': placeId,
                                                'rating': 5})
        assert 'ratings' in str(rv.data)

        rv = self.json_post('/ratePlace/alex', {'uid': placeId,
                                                'rating': 4})
        assert 'ratings' in str(rv.data)

        # Reset prev event
        rv = self.json_get('/getSuggestions/alex', {'uid': uid,
                                                    'query': 'Homewood Campus, Baltimore'})
        sugId = json.loads(rv.data)['uid']
        assert 'business' in str(rv.data)

        rv = self.json_post('/updateEvent/alex', {'uid': uid,
                                                  'choice': '0',
                                                  'suggestionId': sugId})
        assert 'yelpId' in str(rv.data)

        # Set next event
        rv = self.json_get('/getSuggestions/alex', {'uid': uidnext,
                                                    'query': 'Homewood Campus, Baltimore'})
        sugId = json.loads(rv.data)['uid']
        assert 'business' in str(rv.data)

        rv = self.json_post('/updateEvent/alex', {'uid': uidnext,
                                                  'choice': '2',
                                                  'suggestionId': sugId})
        assert 'yelpId' in str(rv.data)

        # Set curr event
        rv = self.json_get('/getSuggestions/alex', {'uid': uidcurr,
                                                    'query': 'Towson, MD'})
        print(rv.data)
        sugId = json.loads(rv.data)['uid']
        assert 'business' in str(rv.data)

        rv = self.json_post('/updateEvent/alex', {'uid': uidnext,
                                                  'choice': '0',
                                                  'suggestionId': sugId})
        assert 'yelpId' in str(rv.data)

        rv = self.json_get('/getEventFromId/alex', {'uid': invuid})
        assert 'Event not found' in str(rv.data)

        rv = self.json_get('/getSuggestions/alex', {'uid': invuid,
                                                     'query': 'Homewood Campus, Baltimore'})
        assert 'Event not found' in str(rv.data)

    def test_getItineraryFromId(self):
        """Test retrieval of itinerary data from uid"""
        date = {'date': '2015-08-21T00:00:00.000Z'}
        # Create sample itinerary for alex for the event day
        self.json_post('/createItinerary/alex', dict(
                name = 'New Day',
                date = date['date']
                ))

        uid = str('alex_' + date['date'])
        invuid = '00000000000000000000000'

        rv = self.json_get('/getItineraryFromId/bbbb', {'uid': uid})
        assert 'Invalid username' in str(rv.data)

        rv = self.json_get('/getItineraryFromId/alex', {'uid': invuid})
        assert 'Itinerary not found' in str(rv.data)

        rv = self.json_get('/getItineraryFromId/alex', {'uid': uid})
        assert uid in str(rv.data)

    def test_deleteItinerary(self):
        """Test removal of itinerary data from uid"""
        event = dict(start = '2015-08-21T01:23:00.000Z',
                     end = '2015-08-21T01:25:00.000Z',
                     date = '2015-08-21T00:00:00.000Z')
        date = {'date': '2015-08-21T00:00:00.000Z'}
        # Create sample itinerary for alex for the event day
        self.json_post('/createItinerary/alex', dict(
                name = 'New Day',
                date = date['date']
                ))
        # Create sample itinerary for naina for the event day
        self.json_post('/createItinerary/naina', dict(
                name = 'New Day1',
                date = date['date']
                ))

        euid = str('alex_' + event['start'] + event['end'])
        naina_euid = str('naina_' + event['start'] + event['end'])
        iuid = str('alex_' + date['date'])
        naina_iuid = str('naina_' + date['date'])
        invuid = '00000000000000000000000'

        rv = self.json_post('/createEvent/alex', event)
        assert euid in str(rv.data)

        # Share event with naina
        rv = self.json_post('/inviteToEvent/alex', dict(
                uid = euid,
                invited = 'naina'
                ))
        assert euid in str(rv.data)

        rv = self.json_post('/createEvent/naina', dict(
                uid = euid
                ))
        assert euid in str(rv.data)

        rv = self.json_delete('/deleteItinerary/bbbb', {'uid': iuid})
        assert 'Invalid username' in str(rv.data)

        rv = self.json_delete('/deleteItinerary/alex', {'uid': invuid})
        assert 'Itinerary not found' in str(rv.data)

        rv = self.json_get('/getItineraryFromId/alex', {'uid': iuid})
        assert iuid in str(rv.data)

        rv = self.json_delete('/deleteItinerary/alex', {'uid': iuid})
        assert iuid in str(rv.data)

        rv = self.json_get('/getItineraryFromId/alex', {'uid': iuid})
        assert 'Itinerary not found' in str(rv.data)

        rv = self.json_delete('/deleteItinerary/naina', {'uid': naina_iuid})
        assert naina_iuid in str(rv.data)

        rv = self.json_get('/getEventFromId/alex', {'uid': euid})
        assert "Event not found" in str(rv.data)

        rv = self.json_get('/getEventFromId/naina', {'uid': naina_euid})
        print(rv.data)
        assert "Event not found" in str(rv.data)

    @unittest.skipIf(os.environ.get('YELP_CONSUMER_KEY') is None,
                     "Please get Yelp secret keys from Bugrahan")
    def test_searchYelp(self):
        ''' Test yelp integration '''
        rv = self.json_get('/searchYelp/San%20Francisco', {})
        print(rv.data)
        assert 'rating' in str(rv.data)
        assert 'id' in str(rv.data)
        assert 'coord' in str(rv.data)
        assert 'name' in str(rv.data)


    # def test_login_logout(self):
    #     """Make sure login and logout works"""
    #     rv = self.login(
    #             flaskr.app.config['USERNAME'],
    #             flaskr.app.config['PASSWORD']
    #         )
    #     assert 'You were logged in' in rv.data

    #     rv = self.logout()
    #     assert 'You were logged out' in rv.data

    #     # Wrong username
    #     rv = self.login(
    #             flaskr.app.config['USERNAME'] + 'x',
    #             flaskr.app.config['PASSWORD']
    #         )
    #     assert 'Invalid Username' in rv.data

    #     # Wrong password
    #     rv = self.login(
    #             flaskr.app.config['USERNAME'],
    #             flaskr.app.config['PASSWORD'] + 'x'
    #         )
    #     assert 'Invalid Password' in rv.data

    # def test_messages(self):
    #     """Test that messages work"""
    #     self.login(
    #             flaskr.app.config['USERNAME'],
    #             flaskr.app.config['PASSWORD']
    #         )
    #     rv = self.app.post('/add', data=dict(
    #             title = '<Hello>',
    #             text = '<strong>HTML</strong> allowed here'
    #         ), follow_redirects=True)
    #     assert 'No entries here so far' not in rv.data
    #     assert '&lt;Hello&gt;' in rv.data
    #     assert '<strong>HTML</strong> allowed here' in rv.data