# -*- coding:utf-8 -*-
"""
    Flaskr Tests
    ~~~~~~~~~~~~
    Tests the Flaskr application
"""
import os
from pymongo import MongoClient
import unittest
from flask_rest_service import app

class PlanItTestCase(unittest.TestCase):

    def setUp(self):
        print("hello")
        self.app = app.test_client()
        app.config['TESTING'] = True
        app.config['MONGO_URI'] = "mongodb://localhost:27017/test"
        # with flask_rest_service.app.app_context():
        mongo = MongoClient(app.config['MONGO_URI'])
        db = mongo.test_database
        app.db = mongo

    def tearDown(self):
        """Get rid of the database again after each test"""
        app.db.drop_database('db')
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
    def test_empty_db(self):
        """Start with a blank database."""
        rv = self.app.get('/')
        print(rv.data)
        assert 'localhost:27017' in rv.data

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

if __name__ == '__main__':
    unittest.main()