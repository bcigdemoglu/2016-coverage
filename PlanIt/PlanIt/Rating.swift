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
    
    var location:String
    var rating: Int
    var time:NSDate = NSDate()
    var interval:NSDateInterval = NSDateInterval()
    
    // MARK: Initialization
    
    init(location: String, time: NSDate) {
        self.location = location
        self.time = time
        self.rating = 0
    }
    
    init?(location: String, rating: Int, time: NSDate, interval: NSDateInterval) {
        self.location = location
        self.time = time
        self.rating = rating
        self.interval = interval
        
        if location.isEqual(nil) {
            return nil
        }
        if rating == 0 {
            return nil
        }
        if time.isEqual(nil) {
            return nil
        }
        if interval.isEqual(nil) {
            return nil
        }
    }
    
    
}
