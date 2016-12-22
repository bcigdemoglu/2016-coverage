//
//  Rating.swift
//  PlanIt
//
//  Created by CS Student on 12/18/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import UIKit

class Rating: NSObject {
    
    //MARK: Properties
    
    public var event: EKEvent
    public var location:String
    public var rating: Int
    public var suggestionID : String
    // MARK: Initialization
    
    init?(event: EKEvent, location: String, rating: Int, suggestionID : String) {
        self.event = event
        self.location = location
        self.rating = rating
        self.suggestionID = suggestionID
    }
    
    
}
class RatingNoEventStore {
    public var location : String
    public var rating : Int
    public var date : String
    public var suggestionID : String
    
    init(location: String, rating : Int, date : String, suggestionID : String) {
        self.location = location
        self.rating = rating
        self.date = date
        self.suggestionID = suggestionID
    }
}
