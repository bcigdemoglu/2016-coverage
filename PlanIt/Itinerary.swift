//
//  Itinerary.swift
//  PlanIt
//
//  Created by Naina Rao on 10/30/16.
//  Copyright © 2016 Amy He. All rights reserved.
//

import UIKit

class Itinerary {
    
    //MARK: Properties
    
    var name: String
    
// MARK: Initialization

    init?(name: String) {
        self.name = name

        if name.isEmpty {
            return nil
        }
    }


}
