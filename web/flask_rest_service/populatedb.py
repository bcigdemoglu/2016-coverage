from flask_rest_service import app, api, mongo, hashpwd

usernames = ["alex", "naina", "amy", "bugi"]

def populateUsers():
    for username in usernames:
        mongo.db.insert({"username": username,
                         "password": hashpwd(username + "123"),
                         "name": username.title()})
