<!-- TOC START min:1 max:3 link:true update:true -->
- [Login](#login)
- [Register](#register)
- [Send Friend Request](#send-friend-request)
- [Respond to Friend Request](#respond-to-friend-request)
- [Get Itinerary Lists](#get-itinerary-lists)
- [Get Itinerary](#get-itinerary)
- [Remove Itinerary](#remove-itinerary)

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

  /itinerarylistshells/<username>

* **Method:**

  `GET`

* **Data Params**

  `{}`

* **Success Response:**

  * **Code:** 200 SUCCESS <br />
    **Content:** `
    { "itineraries":
    [ "createdBy": username, "name": name', "uid": hash] }`

* **Error Response:**

   * **Code:** 404 NOT FOUND <br />
    **Content:** `{ error : "User doesn't exist" }`

* **Sample Call:**
`get('/itinerarylistshells/alex')`
```javascript
{
  "itineraries": [
    {
      "_id": {
        "$oid": "582997df35391365c20ae23f"
      },
      "createdBy": "alex",
      "name": "itin1",
      "uid": "5928551971756020620"
    },
    {
      "_id": {
        "$oid": "582997df35391365c20ae240"
      },
      "createdBy": "alex",
      "name": "itin2",
      "uid": "5928551971756020623"
    },
    {
      "_id": {
        "$oid": "582997df35391365c20ae241"
      },
      "createdBy": "alex",
      "name": "itin3",
      "uid": "5928551971756020622"
    },
    {
      "_id": {
        "$oid": "582997df35391365c20ae242"
      },
      "createdBy": "alex",
      "name": "itin4",
      "uid": "5928551971756020617"
    },
    {
      "_id": {
        "$oid": "582997df35391365c20ae243"
      },
      "createdBy": "alex",
      "name": "itin5",
      "uid": "5928551971756020616"
    }
  ]
}
```

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

# Remove Itinerary
----
  Returns the Itinerary ID when removed from list of itineraries

* **URL**

  /removeItinerary

* **Method:**

  `POST`

* **Data Params**

  `{"user": username,
    "listID": id,
    "last_Sync_TimeStamp": timeStamp}`

* **Success Response:**

  * **Code:** 200 SUCCESS <br />
    **Content:** `{ "ItineraryID": ItineraryID }`

* **Error Response:**

   * **Code:** 404 NOT FOUND <br />
    **Content:** `{ error : "User doesn't exist" }`

   OR

   * **Code:** 404 NOT FOUND <br />
    **Content:** `{ error : "Itinerary doesn't exist" }`

* **Sample Call:**
