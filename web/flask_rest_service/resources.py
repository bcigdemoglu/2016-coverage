"""
Summary
"""
from flask import request, abort, json, session
import flask_restful as restful
from flask_restful import reqparse
from flask_rest_service import app, api, hashpwd
from bson.objectid import ObjectId

class Login(restful.Resource):
    def post(self):
        username_form  = request.get_json()['username']
        user = app.db.db.users.find_one({"username": username_form})
        if not user:
            return {"error": "Invalid username"}, 400

        password_form  = request.get_json()['password']
        encrypted_pass = hashpwd(password_form)

        if user["password"] == encrypted_pass:
            session[username_form] = username_form
            return user, 200

        return {"error": "Incorrect password"}, 401

class Register(restful.Resource):
    def post(self):
        user = {"username": request.get_json()['username'],
                "password": hashpwd(request.get_json()['password']),
                "name": request.get_json()['name']}

        if app.db.db.users.find_one({"username": user["username"]}):
            return {"error": "User already exists"}, 400

        app.db.db.users.insert(user)
        return user, 201

class Root(restful.Resource):
    def get(self):
        return {
            'mongo': str(app.db.db),
            'users': list(app.db.db.users.find())
        }, 200

class GetItineraryList(restful.Resource):
    def get(self, username):
        user = app.db.db.users.find_one({"username": username})
        if not user:
            return {"error": "Invalid username"}, 400

        return {'itineraries':
            list(app.db.db.itin.find({"createdBy": username}))
            }, 201

class PopulateDB(restful.Resource):
    def post(self):
        usernames = ["alex", "naina", "amy", "bugi"]
        for username in usernames:
            # Do not populate if user exists
            if app.db.db.users.find_one({"username": username}):
                continue

            app.db.db.users.insert({"username": username,
                                   "password": hashpwd(username + "123"),
                                   "name": username.title()})
        return {'users': list(app.db.db.users.find())}, 201
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
                if app.db.db.itin.find_one({"uid": itinHash}):
                    continue

                app.db.db.itin.insert({"createdBy": username,
                                       "name": itineraryName,
                                       "uid": itinHash})
        return {'itineraries': list(app.db.db.itin.find())}, 201
    def get(self):
        return self.post()

class DropDB(restful.Resource):
    def delete(self):
        userDropped = app.db.db.users.drop()
        itinDropped = app.db.db.itin.drop()
        return {"userDropped": userDropped, "itinDropped": itinDropped}, 201
    def get(self):
        return self.delete()

api.add_resource(Login, '/login')
api.add_resource(Register, '/register')
api.add_resource(Root, '/')
api.add_resource(PopulateDB, '/testdb/populatedb')
api.add_resource(PopulateItineraries, '/testdb/populateItineraries')
api.add_resource(DropDB, '/testdb/dropdb')
api.add_resource(GetItineraryList, '/itinerarylistshells/<username>')
