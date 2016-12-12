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
let getEvent = "getEvent/"
let searchYelp = "searchYelp/"

//local mode: comment previous line and uncomment next line
//let baseURL = "https://localhost:5000/"

let defaultHeaders : HTTPHeaders = [
    "Content-Type": "application/json"
    ]
/*func sendRequest() -> Int{
    //let printValue = "Didn't work!"
    var statusCode = 12340
    Alamofire.request(baseURL).responseJSON { response in
        print(response.request.)  // original URL request
        print(response.response) // HTTP URL response
        print(response.data)     // server data
        print(response.result)   // result of response serialization
        print("request body: \(request.HTTPBody)")
        if let JSON = response.result.value {
            print("JSON: \(JSON)")
        }
        //print((response.response?.statusCode)!)
    }
    return statusCode
}*/

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
            
            for (index,subJson):(String, JSON) in json {
                let name = subJson[0]["name"].string
                let uid = subJson[0]["uid"].string
                let shell = Itinerary(name: name!, uid: uid!)
                array!.append(shell!)
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
            for(index, subjson) : (String, JSON) in json["invited"] {
                let user : String = subjson["invitedUser"].stringValue
                invitedByUsers += [user]
            }
            var usersAcceptedOrCreated = [String]()
            for(index, subjson) : (String, JSON) in json["accepted"] {
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

