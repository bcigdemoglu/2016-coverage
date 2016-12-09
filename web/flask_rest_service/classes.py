# class SuggestionHandler:
#   """Suggests optimum path
#   """
#   def determineSuggestions(self, userName, itineraryListID):
#     """Puts together list of suggestions based on Users itinerary List

#     Args:
#         userName (str): The Username.
#         itineraryListID (int): The ID of the users current itinerary list

#     Returns:
#         int: Returns the ID of the list of suggestions
#     """
#     pass

#   def recieveSuggestion(self, userName, suggestionListID):
#     """Recieves the suggestion from the suggestion list

#     Args:
#         userName (str): The username.
#         suggestionListID (int): the ID of the list that contains the suggestions

#     Returns:
#         int: Returns the ID of the specific suggestion selected from list
#     """
#     pass

#   def recieveFeedBack(self, userName, yelpPlaceID):
#     """Gives feedback on the location based on the yelpPlaceID

#     Args:
#         userName (str): The Username of the user
#         yelpPlaceID (int): The specific ID of the location from Yelp

#     Returns:
#         int: the numerical star rating of that the user gives the location
#     """
#     pass

#   def __init__(self):
#     """Summary
#     """
#     pass

# class FriendsManager:
#   """Summary
#   """
#   def sendFriendRequest(self, requestingUser, requestedUser):
#     """User sends friends request to another user

#     Args:
#         requestingUser (str): The username of the user being requested
#         requestedUser (str): The username of the requester

#     Returns:
#         bool: True if request went through and false if user requested doesn't exist
#     """
#     pass

#   def acceptRequest(self, requestedUser, requestingUser):
#     """User accepts friends request from other user

#     Args:
#         requestedUser (str): the username of the user being requested
#         requestingUser (str): THe username of the requester

#     Returns:
#         void:
#     """
#     pass

#   def declineRequest(self, requestedUser, requestingUser):
#     """User denies the request of other user

#     Args:
#         requestedUser (str): The username of the user being requested
#         requestingUser (str): The username of the requester

#     Returns:
#         void:
#     """
#     pass

#   def __init__(self):
#     """Initializes user
#     """
#     pass

# class ItineraryListManager:
#   """The Itinerary List Manager
#   """
#   def getListsByUser(self, userEmail):
#     """Gets all the lists of the user

#     Args:
#         userEmail (str): the user email

#     Returns:
#         List: Returns ItneraryList[]
#     """
#     pass

#   def recieveNewItinerary(self, userEmail, itineraryInfo):
#     """Create new Itinerary Item

#     Args:
#         userEmail (str): The email of the user
#         itineraryInfo (str): The info of the itinerary

#     Returns:
#         void:
#     """
#     pass

#   def deleteItineraryList(self, userEmail, listID):
#     """Deletes entire itinerary list

#     Args:
#         userEmail (str): the User email
#         listID (int): the ID of the list being deleted

#     Returns:
#         void:
#     """
#     pass

#   def registerTimeSlot(self, userEmail, itineraryInfo):
#     """Registers the specific time slot for the event created

#     Args:
#         userEmail (str): Users email
#         itineraryInfo (str): The info

#     Returns:
#         void:
#     """
#     pass

#   def unregisterTimeSlot(self, userEmail, itineraryInfo):
#     """Unregisters the specific time slot for the event created

#     Args:
#         userEmail (str): Users email
#         itineraryInfo (str): The info

#     Returns:
#         void:
#     """
#     pass

#   def __init__(self):
#     """Initializes user
#     """
#     pass
