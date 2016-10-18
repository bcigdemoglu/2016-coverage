"""
Summary
"""
from flask import request, abort, json, session
import flask_restful as restful
from flask_restful import reqparse
from flask_rest_service import app, api, mongo, hashpwd
from bson.objectid import ObjectId
import testdb


class Login(restful.Resource):
    def post(self):
        username_form  = request.get_json()['username']
        user = mongo.db.users.find_one({"username": username_form})

        if not user:
            return {"error": "Invalid username"}, 401

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

        if mongo.db.users.find_one({"username": user["username"]}):
            return {"error": "User already exists"}, 400

        mongo.db.users.insert(user)
        return user, 201

class Root(restful.Resource):
    def get(self):
        return {
            'mongo': str(mongo.db),
            'users': list(mongo.db.users.find())
        }, 200

class PopulateDB(restful.Resource):
    def post(self):
        testdb.populateUsers()
        return {'users': list(mongo.db.users.find())}, 201

api.add_resource(Login, '/login')
api.add_resource(Register, '/register')
api.add_resource(Root, '/')
api.add_resource(PopulateDB, '/testdb/populatedb')
