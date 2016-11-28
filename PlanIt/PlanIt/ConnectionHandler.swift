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

func sendLoginRequest(username: String, password: String, completionHandler : @escaping (Int) -> () ) {
    let params: Parameters = [
        "username": username,
        "password": password
    ]
    
    Alamofire.request(baseURL + "login", method: .post, parameters: params, encoding: JSONEncoding.default).response { response in
        print("\(response.data)")
        let code = (response.response?.statusCode)!
        completionHandler(code)
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




