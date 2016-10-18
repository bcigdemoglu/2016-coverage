<!-- TOC START min:1 max:3 link:true update:true -->
- [Login](#login)
- [Register](#register)
- [Get All Users](#get-all-users)

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

# Get All Users
  ----
  All user info.

* **URL**

  /

* **Method:**

  `GET`

* **Data Params**

  None

* **Success Response:**

  * **Code:** 200 OK <br />
    **Content:** `{'users': list_of_users}`

* **Sample Call:**
