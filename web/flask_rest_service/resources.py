"""
Summary
"""
from flask import request, abort, json, session
import flask_restful as restful
from flask_restful import reqparse
from . import api, hashpwd
from bson.objectid import ObjectId
from . import app
from datetime import datetime

class Login(restful.Resource):
    def post(self):
        username  = request.get_json()['username']
        user = app.mongo.db.users.find_one({"username": username})
        if not user:
            return {"error": "Invalid username"}, 400

        password_form  = request.get_json()['password']
        encrypted_pass = hashpwd(password_form)

        if user["password"] != encrypted_pass:
            return {"error": "Incorrect password"}, 401

        # Success
        session[username] = username
        return user, 200

class Register(restful.Resource):
    def post(self):
        user = {"username": request.get_json()['username'],
                "password": hashpwd(request.get_json()['password']),
                "name": request.get_json()['name'],
                "friends": ""}

        if app.mongo.db.users.find_one({"username": user["username"]}):
            return {"error": "User already exists"}, 400

        # Sucess
        app.mongo.db.users.insert(user)
        return user, 201

class Root(restful.Resource):
    def get(self):
        return {
            'mongo': str(app.mongo.db),
            'users': list(app.mongo.db.users.find())
        }, 200

class CreateItinerary(restful.Resource):
    def post(self, username):
        if not app.mongo.db.users.find_one({"username": username}):
            return {"error": "Invalid username"}, 400

        itinerary = {"createdBy": username,
                     "name": request.get_json()['name'],
                     "date": request.get_json()['date'],
                     "uid": ""}

        # Generate itid
        itinerary['uid'] = str(hash(username + "_" + itinerary['date']))

        if app.mongo.db.itin.find_one({"uid": itinerary['uid']}):
            return {"error": "Itinerary date already in use"}, 400

        # Sucess
        app.mongo.db.itin.insert(itinerary)
        return {'uid': itinerary['uid']}, 201

class CreateEvent(restful.Resource):
    def post(self, username):
        if not app.mongo.db.users.find_one({"username": username}):
            return {"error": "Invalid username"}, 400

        if not request.get_json().get('uid'):
            # If event does not exist, create it
            event = {"start": request.get_json()['start'],
                     "end": request.get_json()['end'],
                     "date": request.get_json()['date'],
                     "yelpId": "",
                     "sharedWith": [username],
                     "acceptedBy": [],
                     "uid": ""}
            event['uid'] = str(hash(username + "_" + event['start'] + event['end']))
        else:
            # If event already exists, retrieve it
            event = app.mongo.db.event.find_one({'uid': request.get_json()['uid']})

        if (event['start'] >= event['end']):
            return {"error": "Invalid date range"}, 400

        # Check for collision between other events
        for e in app.mongo.db.event.find({'date': event['date'],
                                          'acceptedBy': { '$eq': username }}):
            if self.checkCollision(event, e):
                return {"error": "Collision with another event"}, 400

        if not app.mongo.db.itin.find_one({"createdBy": username,
                                           "date": event['date']}):
            return {"error": "Itinerary for the day not found"}, 400

        # Sucess
        event['acceptedBy'].append(username)
        if not request.get_json().get('uid'):
            app.mongo.db.event.insert(event)
        else:
            app.mongo.db.event.update({'uid': event['uid']}, event)
        return {'uid': event['uid']}, 201

    @staticmethod
    def checkCollision(event1, event2):
        return (event1['start'] <= event2['end']) and (event2['start'] <= event1['end'])

class GetItineraryList(restful.Resource):
    def get(self, username):
        if not app.mongo.db.users.find_one({"username": username}):
            return {"error": "Invalid username"}, 400

        # Success
        return {'itineraries':
            list(app.mongo.db.itin.find({"createdBy": username}))
            }, 201

class PopulateDB(restful.Resource):
    def post(self):
        usernames = ["alex", "naina", "amy", "bugi"]
        for username in usernames:
            # Do not populate if user exists
            if app.mongo.db.users.find_one({"username": username}):
                continue
            app.mongo.db.users.insert({"username": username,
                                       "password": hashpwd(username + "123"),
                                       "name": username.title()})

        return {'users': list(app.mongo.db.users.find())}, 201

    def get(self):
        return self.post()

class PopulateItineraries(restful.Resource):
    def post(self):
        usernames = ["alex", "naina", "amy", "bugi"]
        itineraryCounter = 1
        for username in usernames:
            for i in range(5):
                itineraryName = "itin"+ str(i + 1)
                itinHash = str(hash(username + "_" + itineraryName))

                # Do not populate if itinerary exists
                if app.mongo.db.itin.find_one({"uid": itinHash}):
                    continue
                app.mongo.db.itin.insert({"createdBy": username,
                                          "name": itineraryName,
                                          "uid": itinHash,
                                          "date": "0"})

        return {'itineraries': list(app.mongo.db.itin.find())}, 201

    def get(self):
        return self.post()

api.add_resource(Login, '/login')
api.add_resource(Register, '/register')
api.add_resource(Root, '/')
api.add_resource(PopulateDB, '/testdb/populatedb')
api.add_resource(PopulateItineraries, '/testdb/populateItineraries')
api.add_resource(GetItineraryList, '/itinerarylistshells/<username>')
api.add_resource(CreateItinerary, '/createItinerary/<username>')
api.add_resource(CreateEvent, '/createEvent/<username>')
