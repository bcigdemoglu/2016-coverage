<!-- TOC START min:1 max:3 link:true update:true -->
- [Login](#login)
- [Register](#register)
- [Create Itinerary](#create-itinerary)
- [Create Event](#create-event)
- [Invite to Event](#invite-to-event)
- [Get Event from ID](#get-event-from-id)
- [Get Events For Itinerary](#get-events-for-itinerary)
- [Get Itinerary from ID](#get-itinerary-from-id)
- [Get Itinerary List](#get-itinerary-list)
- [Search Yelp](#search-yelp)
    - [API Website](#api-websitehttpsgithubcomyelpyelp-python)

<!-- TOC END -->



# Login
----
  Returns user info if login successful.

* **URL**

  /login

* **Method:**

  `POST`

* **Data Params**
    ```javascript
    { "username": username,
      "password": password}
    ```

* **Success Response:**

  * **Code:** 200 OK  
    **Content:**
    ```javascript
    { "username" : "amy1",
      "name" : "Amy He",
      "password": "3b24g23b23y3t3hg" }
    ```

* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Invalid username" }`

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

    ```javascript
    { "username": username,
      "password": password,
      "name": name}
    ```

* **Success Response:**

  * **Code:** 201 CREATED  
    **Content:**
    ```javascript
    { "username" : "amy1",
      "name" : "Amy He",
      "password": "3b24g23b23y3t3hg" }
    ```

* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "User already exists" }`

* **Sample Call:**

# Create Itinerary
----
  Creates a day itinerary for the user.

* **URL**

  /createItinerary/\<username\>

* **Method:**

  `POST`

* **Data Params**

    ```javascript
    { "name" : itinerary_name,
      "date": itinerary_date}
    ```

* **Success Response:**

  * **Code:** 201 CREATED  
    **Content:**
    ```javascript
    { "uid": itinerary_uid }
    ```

* **Error Response:**

   * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Itinerary date already in use" }`

# Create Event
----
  Creates an event for the user without the Yelp location ID,
  or accepts an already created event invitation,
  which also creates a new event for the user.

* **URL**

  /createEvent/\<username\>

* **Method:**

  `POST`

* **Data Params**

  For a completely new event  
    ```javascript
    { "start" : start_date,
      "end": end_date,
      "date": itinerary_date }
    ```

  For accepting an invitation  
    ```javascript
    { "uid": event_uid }
    ```

* **Success Response:**

  * **Code:** 201 CREATED  
    **Content:**
    ```javascript
    { "uid": itinerary_uid }
    ```

* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Invalid date range" }`

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Collision with another event" }`

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Itinerary for the day not found" }`

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "User is not invited" }`

# Invite to Event
----
  Invites another user to an event.

* **URL**

  /inviteToEvent/\<username\>

* **Method:**

  `POST`

* **Data Params**

    ```javascript
    { "invited" : invited_username,
      "uid": event_uid}
    ```

* **Success Response:**

  * **Code:** 201 CREATED  
    **Content:**
    ```javascript
    { "uid": event_uid }
    ```

* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Invalid event id" }`

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Shared user does not exist" }`

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Already sent invitation" }`

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Already shared with user" }`

# Get Event from ID
----
  Returns event object if the user has access to the event.

* **URL**

  /getEventFromId/\<username\>

* **Method:**

  `GET`

* **Data Params**

    ```javascript
    { "uid": event_uid }
    ```

* **Success Response:**

  * **Code:** 200 OK  
    **Content:**
    ```javascript
    { "start": event_start_time,
      "end": event_end_time,
      "date": itinerary_date,
      "yelpId": location_yelp_id,
      "invited": [ invitation_pending_users ],
      "acceptedBy": [ users_accepted_or_created_the_event ],
      "uid": event_uid }
    ```

* **Error Response:**

  * **Code:** 400 BAD REQUEST  
    **Content:** `{ error : "Event not found" }`

# Get Events For Itinerary
----
  Returns an event object array for all events for an existing itinerary.

* **URL**

  /getEventFromId/\<username\>

* **Method:**

  `GET`

* **Data Params**

    ```javascript
    { "date": itinerary_date }
    ```

* **Success Response:**

  * **Code:** 200 OK  
    **Content:**
    ```javascript
    { "events":
      [
        // This is an event object
        { "start": event_start_time,
          "end": event_end_time,
          "date": itinerary_date,
          "yelpId": location_yelp_id,
          "invited": [ invitation_pending_users ],
          "acceptedBy": [ users_accepted_or_created_the_event ],
          "uid": event_uid }
      ]
    }
    ```

* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Itinerary for the day not found" }`

# Get Itinerary from ID
----
  Returns itinerary object data if the user created the itinerary.

* **URL**

  /getEventFromId/\<username\>

* **Method:**

  `GET`

* **Data Params**

    ```javascript
    { "uid": itinerary_uid }
    ```

* **Success Response:**

  * **Code:** 200 OK  
    **Content:**
    ```javascript
    { "createdBy": username,
      "name": itinerary_name,
      "date": itinerary_date,
      "uid": itinerary_uid }
    ```

* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Itinerary not found" }`

# Get Itinerary List
----
  Returns a list all of itineraries.

* **URL**

  /getEventFromId/\<username\>

* **Method:**

  `GET`

* **Data Params**

    ```javascript
    { "date": itinerary_date }
    ```

* **Success Response:**

  * **Code:** 200 OK  
    **Content:**
    ```javascript
    { "itineraries":
      [
        // This is an itinerary object
        { "createdBy": username,
          "name": itinerary_name,
          "date": itinerary_date,
          "uid": itinerary_uid }
      ]
    }
    ```

* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Itinerary for the day not found" }`

# Yelp Integration
---
### [API Website](https://github.com/Yelp/yelp-python)
  Returns yelp data for a business given a query  

* **URL**

  /searchYelp/\<query\>

* **Method:**

  `GET`

* **Data Params**
    See API Website
    ```javascript
    // Example for Search API
    { 'term': 'food',
      'lang': 'fr'
    }
    ```

* **Success Response:**

  * **Code:** 200 OK  
    **Content:** Business info as shown on the website
    ```javascript
    { }
    ```
