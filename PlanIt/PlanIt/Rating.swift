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
    // MARK: Initialization
    
    init?(event: EKEvent, location: String, rating: Int) {
        self.event = event
        self.location = location
        self.rating = rating
    }
    
    
}
class RatingNoEventStore {
    public var location : String
    public var rating : Int
    public var date : String
    
    init(location: String, rating : Int, date : String) {
        self.location = location
        self.rating = rating
        self.date = date
    }
}
