"""Summary
"""
from flask import request, abort, json, session
import flask_restful as restful
from flask_restful import reqparse
from flask_rest_service import app, api, mongo
from bson.objectid import ObjectId
from md5 import md5

# User: Username <Email>, Password, Friends <List of Usernames>
#

class Login(restful.Resource):
    def post(self):
        username_form  = request.form['username']
        user = mongo.db.users.find_one({"username": username_form})

        if not user:
            raise ServerError('Invalid username')

        password_form  = request.form['password']
        encrypted_pass = md5(password_form).hexdigest()

        if user.password == encrypted_pass:
            session[username_form] = username_form
            return {"statusCode": 200, user}

        raise ServerError('Invalid password')

class Register(restful.Resource):
    def post(self):
        user = {"username": request.form['username'],
                "password": md5(request.form['password']).hexdigest(),
                "name": request.form['username']}
        mongo.db.users.insert(user)
        return user

class Root(restful.Resource):
    def get(self):
        return {
            'status': 'OK',
            'mongo': str(mongo.db),
            mongo.db.users.find()
        }

'''
@app.route('/login', methods=['GET', 'POST'])
def login():
    """Summary

    Returns:
        TYPE: Description

    Raises:
        ServerError: Description
    """
    if 'username' in session:
        return redirect(url_for('index'))

    error = None
    try:
        if request.method == 'POST':
            username_form  = request.form['username']
            username = mongo.db.users.find_one({"userId": testing_id})

            if not username:
                raise ServerError('Invalid username')

            password_form  = request.form['password']
            cur.execute("SELECT pass FROM users WHERE name = {};"
                        .format(username_form))

            for row in cur.fetchall():
                if md5(password_form).hexdigest() == row[0]:
                    session['username'] = request.form['username']
                    return redirect(url_for('index'))

            raise ServerError('Invalid password')
    except ServerError as e:
        error = str(e)

    return render_template('login.html', error=error)


@app.route('/logout')
def logout(asdasd,das das d):
    session.pop('username', None)
    return redirect(url_for('index'))
'''

# class Inserter(restful.Resource):
#     def get(self):
#         testing_id = mongo.db.testing.insert({"trial_key" : "trial_val"})
#         return mongo.db.testing.find_one({"_id": testing_id})

# @app.route('/rem', methods=['GET'])
# def remove_from_database():
#     testing_id = mongo.db.testing.remove({"trial_key": "trial_val"})
#     return testing_id

# class Finder(restful.Resource):
#     def get(self):
#         return [x for x in mongo.db.testing.find({"trial_key": "trial_val"})]

# class ReadingList(restful.Resource):
#     def __init__(self, *args, **kwargs):
#         self.parser = reqparse.RequestParser()
#         self.parser.add_argument('reading', type=str)
#         super(ReadingList, self).__init__()

#     def get(self):
#         return [x for x in mongo.db.readings.find()]

#     def post(self):
#         args = self.parser.parse_args()
#         if not args['reading']:
#             abort(400)
#         with open('pylog.txt', 'w') as file_:
#             file_.write(args['reading'])
#         jo = json.loads(args['reading'])
#         reading_id =  mongo.db.readings.insert(jo)
#         return mongo.db.readings.find_one({"_id": reading_id})


# class Reading(restful.Resource):
#     def get(self, reading_id):
#         return mongo.db.readings.find_one_or_404({"_id": reading_id})

#     def delete(self, reading_id):
#         mongo.db.readings.find_one_or_404({"_id": reading_id})
#         mongo.db.readings.remove({"_id": reading_id})
#         return '', 204

api.add_resource(Login, '/login')
api.add_resource(Register, '/register')
api.add_resource(Root, '/')
api.add_resource(ReadingList, '/readings/')
api.add_resource(Reading, '/readings/<ObjectId:reading_id>')

api.add_resource(Finder, '/find')
api.add_resource(Inserter, '/ins')
