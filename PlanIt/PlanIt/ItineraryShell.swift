//
//  ItineraryShell.swift
//  PlanIt
//
//  Created by Alex Owen on 11/13/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import Foundation


class ItineraryShell {
    var name: String
    //var name: String = ""
    var uid: String

    // MARK: Initialization

    init?(name: String, uid: String) {
        self.name = name
        self.uid = uid
        if name.isEmpty {
            return nil
        }
        if uid.isEmpty {
            return nil
        }
    }

}
