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
    
    var name: String
    //var name: String = ""
    
// MARK: Initialization

   init?(name: String) {
        self.name = name

        if name.isEmpty {
            return nil
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
