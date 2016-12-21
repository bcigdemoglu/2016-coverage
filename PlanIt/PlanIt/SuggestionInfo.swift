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
    
    var uid : String?
    
    
    init(name : String?, numberStars : Int?, uid : String?) {
        self.displayName = name
        self.numberStars = numberStars
        self.uid = uid
    }
    
    
    func getName() -> String? {
        return self.displayName
    }
    
    func getStars() -> Int? {
        return self.numberStars
    }
    
    func getuid() -> String? {
        return self.uid
    }
}
