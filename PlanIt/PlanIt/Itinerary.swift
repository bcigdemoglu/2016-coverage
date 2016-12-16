//
//  Itinerary.swift
//  PlanIt
//
//  Created by Naina Rao on 10/30/16.
//  Copyright © 2016 Amy He. All rights reserved.
//

import UIKit

//Add NSObject, NSCoding to class

class Itinerary{
    
    //MARK: Properties
    
    var name:String
    //var name: String = ""
    var uid: String
    var date:NSDate = NSDate() 
    
// MARK: Initialization

    init(name: String, uid: String) {
        self.name = name
        self.uid = uid
    }

    init?(name: String, date: NSDate, uid: String) {
        self.name = name
        self.uid = uid
        if name.isEqual(nil) {
            return nil
        }
        if uid.isEmpty {
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
