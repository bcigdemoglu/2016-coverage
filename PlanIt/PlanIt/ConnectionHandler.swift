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

func sendLoginRequest(username: String, password: String, loginController : LoginPageViewController) -> Int{
    let params: Parameters = [
        "username": username,
        "password": password
    ]
    
    var statusCode = 0
    Alamofire.request(baseURL + "login", method: .post, parameters: params, encoding: JSONEncoding.default).validate().responseJSON { response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            print("JSON: \(json)")
            loginController.performSegue(withIdentifier: "ListViewSegue", sender: nil)
        case .failure(let error):
            print(error)
            statusCode = 1;
        }
    }
    return statusCode;

}

func sendRegisterRequest(username: String, password: String, name : String) {
    let parameters: Parameters = [
        "username": username,
        "password": password,
        "name" : name
    ]

    //var statusCode = 0
    Alamofire.request(baseURL + "login", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
        print(response.request?.httpBody)  // original URL request
        print(response.response) // HTTP URL response
        print(response.data)     // server data
        print(response.result)   // result of response serialization
        
        if let JSON = response.result.value {
            print("JSON: \(JSON)")
        }
    }
}

/*func getItineraryList(username : String, timestamp : u_long) -> [Itinerary]{
    var array = [Itinerary]()
    let parameters: Parameters = [
        "username" : username,
        "last_sync_timestamp" : timestamp
    ]
    Alamofire.request(baseURL + "getItineraryLists", method: .get, parameters : parameters, encoding: JSONEncoding.default).responseJSON { response in
       
}*/



