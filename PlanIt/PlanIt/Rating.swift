//
//  Rating.swift
//  PlanIt
//
//  Created by CS Student on 12/18/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import UIKit

class Rating {
    
    //MARK: Properties
    
    var event: EKEvent
    var location:String
    var uid: String
    var rating: Int
    // MARK: Initialization
    
    init?(event: EKEvent, location: String, uid: String, rating: Int) {
        self.event = event
        self.location = location
        self.uid = uid
        self.rating = rating
    }
    
    
}
