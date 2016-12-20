//
//  Suggestion.swift
//  PlanIt
//
//  Created by Naina Rao on 12/20/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import Foundation
import UIKit

//Add NSObject, NSCoding to class

class Suggestion{
    
    //MARK: Properties
    
    var location:String
    //var name: String = ""
    var locationID: String
    var date:NSDate = NSDate()
    
    // MARK: Initialization
    
    init(location: String, locationID: String) {
        self.location = location
        self.locationID = locationID
    }
    
    init?(location: String, date: NSDate, locationID: String) {
        self.location = location
        self.locationID = locationID
        self.date = date

        if location.isEqual(nil) {
            return nil
        }
        if locationID.isEmpty {
            return nil
        }
        if date.isEqual(nil) {
            return nil
        } else {
            self.date = date
        }
    }
    
    
    //To implement later for storage
    /**  required init?(coder decoder: NSCoder) {
     super.init()
     var name: String
     if let archivedName = decoder.decodeObject(forKey: "name") as? String {
     name = archivedName
     }
     // super.init()
     
     }
     
     func encode(with coder: NSCoder) {
     coder.encode(name, forKey: "name")
     } **/
    
    
}

