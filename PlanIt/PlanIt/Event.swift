//
//  Event.swift
//  PlanIt
//
//  Created by Alex Owen on 12/8/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import Foundation

class Event {
    
    //MARK: Properties
    var start : String
    
    var end : String
    
    var date : String
    
    var yelpId : String
    
    var invitedByUsers : [String]
    
    var accpetedByUsers : [String]
    
    var uid : String
    
    //MARK: Initialization
    //Full constructor
    init?(start : String, end : String, date : String, yelpId : String, invited: [String], accepted: [String], uid : String ) {
        self.start = start
        self.end = end
        self.date = date
        self.yelpId = yelpId
        self.uid = uid
        self.invitedByUsers = invited
        self.accpetedByUsers = accepted
    }
    
    
    
}


