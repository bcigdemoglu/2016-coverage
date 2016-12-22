//
//  ConnectionHandler.swift
//  AlamofireStart
//
//  Created by Alex Owen on 10/29/16.
//  Copyright © 2016 Oose2016. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

let baseURL = "https://oose-2016-group-13.herokuapp.com/"
//let baseURL = "https://localhost:5000/"
let createItinerary = "createItinerary/"
let createEvent = "createEvent/"
let inviteToEvent = "inviteToEvent/"
let suggestions = "getSuggestions/"
let getEvent = "getEvent/"
let searchYelp = "searchYelp/"
let respond = "respond/"
let changeDisplayName = "changeDisplayName/"
let changePassword = "changePassword/"
let deleteItinerary = "deleteItinerary/"
let ratePlace = "ratePlace/"
let updateEvent = "updateEvent/"


//local mode: comment previous line and uncomment next line
//let baseURL = "https://localhost:5000/"

let defaultHeaders : HTTPHeaders = [
    "Content-Type": "application/json"
    ]

func sendLoginRequest(username: String, password: String, completionHandler : @escaping (String) -> () ) {
    let params: Parameters = [
        "username": username,
        "password": password
    ]
    
    Alamofire.request(baseURL + "login", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
        print("\(response.data)")
        //let code = (response.response?.statusCode)!
        switch response.result {
        case .success :
                completionHandler("success")
        case .failure(let error) :
            print(error)
            completionHandler(error.localizedDescription)
            
        }
    }
}


func sendRegisterRequest(username: String, password: String, name : String, completionHandler : @escaping (Int) -> () ) {
    let parameters: Parameters = [
        "username": username,
        "password": password,
        "name" : name
    ]
    Alamofire.request(baseURL + "register", method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
        print("\(response.data)")
        let code = (response.response?.statusCode)!
        completionHandler(code)
    }
}

func getItineraryListShells(userID : String, completionHandler: @escaping ([Itinerary]?, String) -> ()) {
    Alamofire.request(baseURL + "itinerarylistshells/" + userID, method: .get, encoding: JSONEncoding.default).responseJSON { response in
        var array : [Itinerary]? = []
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            print("JSON: \(json)")
            
            for (_,subJson) in json["itineraries"] {
                //Changed so the name returned is of NSDate type, not a string. 
                let name = subJson["name"].string
                let uid = subJson["uid"].string
                let dateJSON = subJson["date"].string
                let shell:Itinerary
                if (dateJSON == nil ) {
                    shell = Itinerary(name: name!, uid: uid!)
                   // array!.append(shell)
                } else {
                    let dateFor: DateFormatter = DateFormatter()
                    dateFor.dateFormat = "yyyy-MM-dd"
                    let date: NSDate? = dateFor.date(from: dateJSON!) as NSDate?
                
                //let uid = subJson["uid"].string
                    shell = Itinerary(name: name!, date: date!, uid: uid!)!
                    //array!.append(shell!)
                }
                array!.append(shell)
            }
            completionHandler(array, "")
        case .failure(let error):
            print(error)
            completionHandler(array, error.localizedDescription)
        }
    }
}

func postCreateItinerary(userID: String, itineraryName: String, date: String, completionHandler: @escaping (Int, String?) -> ()) {
    let parameters : Parameters = [
    "name" : itineraryName,
    "date" : date
    ]
    Alamofire.request(baseURL + createItinerary + userID, method : .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            print("JSON: \(json)")
            var uid : String?
            for (_,subJson):(String, JSON) in json {
                uid = subJson[0]["uid"].string
            }
            completionHandler(response.response!.statusCode, uid)
        case .failure(let error):
            print(error)
            completionHandler(response.response!.statusCode, error.localizedDescription)
        }
    }
}

func deleteItinerary(itineraryID: String,  completionHandler : @escaping (String?) -> ()) {
    let parameters : Parameters = [
        "uid" : itineraryID
    ]
    Alamofire.request(baseURL + deleteItinerary + User.getUserName()!, method: .delete, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success :
            completionHandler(nil)
        case .failure (let error) :
            completionHandler (error.localizedDescription)
        }
    }
}

func sendChangePassword(newPassword: String, completionHandler: @escaping (String?) -> ()) {
    let parameters : Parameters =
    [
        "old_password" : User.getUserPassword()!,
        "new_password" : newPassword
    ]
    Alamofire.request(baseURL + changePassword + User.getUserName()!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success:
            completionHandler(nil)
        case .failure (let error) :
            completionHandler(error.localizedDescription)
            
        }
    }
}

func sendChangeDisplayName(newDisplayName: String, completionHandler: @escaping (String?) -> ()) {
    let parameters : Parameters =
        [
            "password" : User.getUserPassword()!,
            "displayName" : newDisplayName
    ]
    Alamofire.request(baseURL + changeDisplayName + User.getUserName()!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success:
            completionHandler(nil)
        case .failure (let error) :
            completionHandler(error.localizedDescription)
            
        }
    }
}

func createEvent(start : String, end : String, date : String, completionHandler : @escaping (Int, String?) -> ()) {
    let parameters : Parameters = [
        "start" : start,
        "end" : end,
        "date" : date
    ]
    postCreateEvent(parameters: parameters) { statusCode, str in
        completionHandler(statusCode, str)
    }
    
}

func acceptInvite(eventID : String, completionHandler : @escaping (Int, String?) -> ()) {
    let parameters : Parameters = [
        "uid" : eventID
    ]
    postCreateEvent(parameters: parameters) { statusCode, str in
        completionHandler(statusCode, str)
    }
}

func postCreateEvent(parameters : Parameters, completionHandler : @escaping (Int, String?) -> ()) {
    Alamofire.request(baseURL + createEvent + User.getUserName()!, method : .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            print("JSON: \(json)")
            var uid = json["uid"].string
            completionHandler(response.response!.statusCode, uid)
        case .failure(let error):
            print(error)
            completionHandler(response.response!.statusCode, error.localizedDescription)
        }
        
    }
}

func postInviteToEvent (userID: String, inviteeUserID : String, eventUID : String, completionHandler : @escaping (Int, String?) -> ()) {
    let parameters : Parameters = [
        "invited" : inviteeUserID,
        "uid" : eventUID
    ]
    Alamofire.request(baseURL + inviteToEvent + userID, method : .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            print("JSON: \(json)")
            var uid : String?
            for (_,subJson):(String, JSON) in json {
                uid = subJson[0]["uid"].string
            }
            completionHandler(response.response!.statusCode, uid)
        case .failure(let error):
            print(error)
            completionHandler(response.response!.statusCode, error.localizedDescription)
        }
    }
    
}

func getSuggestionsForEvent(eventId : String, eventQuery: String, completionHandler : @escaping ([SuggestionInfo]?, String?, String?) -> ()) {
    let parameters : Parameters = [
    "uid" : eventId,
    "query" : eventQuery
    ]
    Alamofire.request(baseURL + suggestions + User.getUserName()!, method : .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success (let value) :
            let json = JSON(value)
            print("JSON: \(json)")
            var array = [SuggestionInfo]()
            var nameArray = [String]()
            var starArray = [Int]()
            var uid = json["uid"].string!
            for (_,subJson) in json["business"] {
                nameArray.append(subJson["name"].string!)
            }
            var scoreJsonArray = json["scores"].arrayValue
            for (str) in scoreJsonArray  {
                let stars = str.doubleValue * 5
                starArray.append(lround(stars))
            }
            for i in 0...2 {
                let si = SuggestionInfo(name: nameArray[i], numberStars: starArray[i])
                array.append(si)
            }
            completionHandler(array, uid, nil)
        case .failure(let error) :
            completionHandler(nil, nil, error.localizedDescription)
        }
        
    }
}

func sendChoice(eventID : String, suggestionID: String, choiceName: Int, completionHandler: @escaping (String?) -> ()) {
    let parameters : Parameters = [
        "uid" : eventID,
        "suggestionId" : suggestionID,
        "choice" : choiceName
    ]
    Alamofire.request(baseURL + updateEvent + User.getUserName()!, method : .post, parameters: parameters,  encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success:
            completionHandler("Success")
        case .failure(let error):
            completionHandler(error.localizedDescription)
            
        }
        
    }
}


func sendRating(suggestionID: String, rating: Int, date : String, completionHandler: @escaping (String?) -> ()) {
    let parameters : Parameters = [
        "uid" : suggestionID,
        "rating" : rating,
        "date" : date
    ]
    Alamofire.request(baseURL + ratePlace + User.getUserName()!, method : .post, parameters: parameters,  encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success:
            completionHandler("Success")
        case .failure(let error):
            completionHandler(error.localizedDescription)
            
        }
        
    }}

func getOutstandingRatings(completionHandler : @escaping ([RatingNoEventStore], String?) -> ()) {
    Alamofire.request(baseURL + ratePlace + User.getUserName()!, method : .get, encoding: JSONEncoding.default).responseJSON {
        response in
        var array = [RatingNoEventStore]()
        switch response.result {
        case .success (let value):
            let json = JSON(value)
            print(json)
            for (_, subJSON) in json["places"] {
                let loc = subJSON["name"].string
                let date = subJSON["date"].string
                //not sure why these are necessary
                let rating = 1
                let uid = subJSON["uid"].string
                array.append(RatingNoEventStore(location: loc!, rating: rating, date: date!, suggestionID: uid!))
            }
            completionHandler(array, nil)
        case .failure(let error): 
            completionHandler(array, error.localizedDescription)
            
        }
    }
}

func sendGetEvents(itineraryDate : String?, completionHandler: @escaping (String?, [Event?]) -> ()) {
    let parameters : Parameters = [
        "date" : itineraryDate!
    ]
    Alamofire.request(baseURL + "getEventsForItinerary/" + User.getUserName()!, method : .get, parameters : parameters, encoding: JSONEncoding.default).responseJSON {
        response in
        var array = [Event?]()
        switch response.result {
        case .success (let value):
            let json = JSON(value)
            for(_, subJson) in json["events"] {
                let uid = subJson["uid"].string
                let start = subJson["start"].string
                let end = subJson["end"].string
                let date = subJson["date"].string
                let eventInfo = Event(start : start!, end : end!, date : date!, uid : uid!);
                array.append(eventInfo)
            }
            completionHandler("Success", array)
        case .failure(let error):
            completionHandler(error.localizedDescription, array)
            
        }
    }
}
