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
let createItinerary = "createItinerary/"
let createEvent = "createEvent/"
let inviteToEvent = "inviteToEvent/"
let suggestions = "suggestions/"
let getEvent = "getEvent/"
let searchYelp = "searchYelp/"
let respond = "respond/"
let changeDisplayName = "changeDisplayName/"
let changePassword = "changePassword/"
let deleteItinerary = "deleteItinerary/"


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
                var dateJSON = subJson["date"].string
                let shell:Itinerary
                if (dateJSON == nil ) {
                    shell = Itinerary(name: name!, uid: uid!)
                   // array!.append(shell)
                } else {
                    let dateFor: DateFormatter = DateFormatter()
                    dateFor.dateFormat = "yyyy-MM-dd"
                    var date: NSDate? = dateFor.date(from: dateJSON!) as NSDate?
                
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

func createEvent(userID: String, start : String, end : String, date : String, completionHandler : @escaping (Int, String?) -> ()) {
    let parameters : Parameters = [
        "start" : start,
        "end" : end,
        "date" : date
    ]
    postCreateEvent(userID: userID, parameters: parameters) { statusCode, str in
        completionHandler(statusCode, str)
    }
    
}

func acceptInvite(userID : String, eventID : String, completionHandler : @escaping (Int, String?) -> ()) {
    let parameters : Parameters = [
        "uid" : eventID
    ]
    postCreateEvent(userID: userID, parameters: parameters) { statusCode, str in
        completionHandler(statusCode, str)
    }
}

func postCreateEvent( userID: String, parameters : Parameters, completionHandler : @escaping (Int, String?) -> ()) {
    Alamofire.request(baseURL + createEvent + userID, method : .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            print("JSON: \(json)")
            var uid : String?
            //might need just the full json here, as its just one thing.
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

func getEventFromID(userID: String, eventID : String, completionHandler : @escaping (Event, String?) -> ()) {
    let parameters : Parameters = [
    "uid" : eventID
    ]
    Alamofire.request(baseURL + getEvent + userID, method : .get, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            print("JSON: \(json)")
            let startDate = json["start"].string
            let endDate = json["end"].string
            let date = json["date"].string
            let yelpId = json["yelpId"].string
            var invitedByUsers = [String]()
            for(_, subjson) : (String, JSON) in json["invited"] {
                let user : String = subjson["invitedUser"].stringValue
                invitedByUsers += [user]
            }
            var usersAcceptedOrCreated = [String]()
            for(_, subjson) : (String, JSON) in json["accepted"] {
                let user = subjson["acceptededUser"].stringValue
                usersAcceptedOrCreated += [user]
            }
            let uid = json["uid"].stringValue
            let event = Event(start: startDate!, end: endDate!, date: date!, yelpId: yelpId!, invited: invitedByUsers, accepted: usersAcceptedOrCreated, uid: uid)
            completionHandler(event!, uid)
        case .failure(let error):
            print(error)
            let nilEvent = Event(start: "", end: "", date: "", yelpId: "", invited: [String](), accepted: [String](), uid: "")
            completionHandler(nilEvent!, error.localizedDescription)
        }
    }
}


func getSuggestionsForEvent(eventID: String, longitude: Double, latitude: Double, completionHandler : @escaping ([SuggestionInfo]?, String?) -> ()) {
    let longString: String = String(format: "%f", longitude)
    let latString: String = String(format: "%f", latitude)
    let parameters : Parameters = [
        "longitude" : longString,
        "latitude" : latString
    ]
    Alamofire.request(baseURL + suggestions + User.getUserName()! + "/" + eventID, method : .get, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success (let value) :
            let json = JSON(value)
            var array = [SuggestionInfo]()
            for (_,subJson) in json["suggestions"] {
                let name = subJson["name"].string
                let stars = subJson["stars"].intValue
                let sI = SuggestionInfo(name: name, numberStars: stars)
                array.append(sI)
            }
            completionHandler(array, nil)
        case .failure(let error) :
            completionHandler(nil, error.localizedDescription)
        }
        
    }
}

func sendChoice(eventID: String, choiceName: String, completionHandler: @escaping (String?) -> ()) {
    let parameters : Parameters = [
        "choice" : choiceName
    ]
    Alamofire.request(baseURL + suggestions + User.getUserName()! + "/" + eventID, method : .post, parameters: parameters,  encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success:
            completionHandler("Success")
        case .failure(let error):
            completionHandler(error.localizedDescription)
            
        }
        
    }
}


func sendRating(eventID: String, choiceName: String, rating: Int, completionHandler: @escaping (String?) -> ()) {
    let parameters : Parameters = [
        "choice" : choiceName,
        "rating" : rating
    ]
    Alamofire.request(baseURL + suggestions + respond + User.getUserName()! + "/" + eventID, method : .post, parameters: parameters,  encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success:
            completionHandler("Success")
        case .failure(let error):
            completionHandler(error.localizedDescription)
            
        }
        
    }}
//func getEventFromItinerary(userID: String, )


/*func searchYelp(query : String, term : String, language : String, completionHandler : @escaping (YelpInfo?, String)) {
    let parameters : Parameters = [
        "term" : term,
        "lang" : language
    ]
    Alamofire.request(baseURL + searchYelp, method : .get, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
        response in
        switch response.result {
        case .success(let value) :
            
            
        case .failure(let error) :
            completionHandler(
        }
        
    }
    
}
 */

