<!-- TOC START min:1 max:3 link:true update:true -->
- [Login](#login)
- [Register](#register)
- [Send Friend Request](#send friend request)
- [Register](#register)
- [Login](#login)
- [Register](#register)


<!-- TOC END -->



# Login
----
  Returns user info if login successful.

* **URL**

  /login

* **Method:**

  `POST`

* **Data Params**

  `{"username": username,
    "password": password}`

* **Success Response:**

  * **Code:** 200 OK <br />
    **Content:** `{ "username" : "amy1", "name" : "Amy He", "password": "3b24g23b23y3t3hg" }`

* **Error Response:**

  * **Code:** 404 NOT FOUND <br />
    **Content:** `{ error : "User doesn't exist" }`

  OR

  * **Code:** 401 UNAUTHORIZED <br />
    **Content:** `{ error : "Incorrect password" }`

* **Sample Call:**

# Register
----
  Returns user info if registration successful.

* **URL**

  /register

* **Method:**

  `POST`

* **Data Params**

`{"username": username,
              "password": password,
              "name": name}`

* **Success Response:**

  * **Code:** 201 CREATED <br />
    **Content:** `{ "username" : "amy1", "name" : "Amy He", "password": "3b24g23b23y3t3hg" }`

* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "User already exists" }`

* **Sample Call:**

# Send Friend Request
----
  Returns requesting user and requested user info if friend request is successfully sent.

* **URL**

  /friendRequest

* **Method:**

  `POST`

* **Data Params**

  `{"requestingUser": username,
    "requestedUser": friendUsername}`

* **Success Response:**

  * **Code:** 200 SUCCESS <br />
    **Content:** `{ "requestingUser": username, "requestedUser": friendUsername}`

* **Error Response:**

  * **Code:** 404 NOT FOUND <br />
    **Content:** `{ error : "Requested or requesting user doesn't exist" }`

* **Sample Call:**

# Respond to Friend Request
----
  Returns boolean whether friend requested or not.

* **URL**

  /friendRequestRespond

* **Method:**

  `POST`

* **Data Params**

  `{"requestingUser": username,
    "requestedUser": friendUsername, "respond": accept}`

* **Success Response:**

  * **Code:** 200 SUCCESS <br />
    **Content:** `{ "respond": accept}`

* **Error Response:**

  * **Code:** 404 NOT FOUND <br />
    **Content:** `{ error : "Requested or requesting user doesn't exist" }`

* **Sample Call:**


# Get Itinerary Lists
----
  Returns user's list of day itineraries.

* **URL**

  /getItineraryLists

* **Method:**

  `GET`

* **Data Params**

  `{"user": username,
    "last_Sync_TimeStamp": timeStamp}`

* **Success Response:**

  * **Code:** 200 SUCCESS <br />
    **Content:** `{ "ItineraryList": ArrayList<Itinerary> }`

* **Error Response:**

   * **Code:** 404 NOT FOUND <br />
    **Content:** `{ error : "User doesn't exist" }`

* **Sample Call:**

# Get Itinerary
----
  Returns a specific Day Itinerary.

* **URL**

  /getItineraryID

* **Method:**

  `GET`

* **Data Params**

  `{"user": username,
    "listID": id,
    "last_Sync_TimeStamp": timeStamp}`

* **Success Response:**

  * **Code:** 200 SUCCESS <br />
    **Content:** `{ "Itinerary": Itinerary }`

* **Error Response:**

   * **Code:** 404 NOT FOUND <br />
    **Content:** `{ error : "User doesn't exist" }`
       
   OR
  
   * **Code:** 404 NOT FOUND <br />
    **Content:** `{ error : "Itinerary doesn't exist" }`

* **Sample Call:**



