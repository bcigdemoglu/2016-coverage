from flask_rest_service import app, api, hashpwd

usernames = ["alex", "naina", "amy", "bugi"]

def populateUsers():
    for username in usernames:
        app.db.db.users.insert({"username": username,
                               "password": hashpwd(username + "123"),
                               "name": username.title()})
