//
//  SuggestionInfo.swift
//  PlanIt
//
//  Created by Alex Owen on 12/14/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import Foundation

class SuggestionInfo {
    var displayName : String?
    
    var numberStars : Int?
    
    var longitude : Double?
    
    var latitude : Double?
    init(name : String?, numberStars : Int?) {
        self.displayName = name
        self.numberStars = numberStars
    }
    
    func getName() -> String? {
        return self.displayName
    }
    
    func getStars() -> Int? {
        return self.numberStars
    }
}
