//
//  User.swift
//  PlanIt
//
//  Created by Alex Owen on 12/13/16.
//  Copyright © 2016 oosegroup13. All rights reserved.
//

import Foundation

class User {
    
    //Mark:  Properties
    var currentUser : String?
    
    var currentPassword : String?
    
    
    static var onlyUser : User = User()!
    
    private init?(user : String?, password : String?) {
        self.currentUser = user
        self.currentPassword = password
    }
    
    private init?() {
        self.currentUser = nil
        self.currentPassword = nil
    }
    
    static func createUser(user : String?, password : String?) {
        let singleInstance = User(user : user, password : password)
        onlyUser = singleInstance!
    }
    
    static func getUser() -> User {
        return onlyUser
    }
    /*
     How about throwing an error if create User has not been called yet?  This would be good OO design, 
     but needs to be left as an optional thing while we aren't done with more important things.
     */
    static func getUserName() -> String? {
        return onlyUser.currentUser
    }
    
    static func getUserPassword() -> String? {
        return onlyUser.currentPassword
    }
}
