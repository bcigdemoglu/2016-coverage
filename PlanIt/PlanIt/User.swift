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
    
    var displayName : String?
    
    private var nextPassword : String?
    
    private var nextDisplayName : String?
    
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
    
    static func getDisplayName() -> String? {
        return onlyUser.displayName
    }
    
    static func changeUserPassword(newPassword : String, completionHandler : @escaping (String?) -> ()) {
        setPotentialPassword(newPass: newPassword)
        sendChangePassword(newPassword: newPassword) { responseString in
            if (responseString == nil) {
                cementNewPassword()
            }
            completionHandler(responseString)
        }
    }
    
    private static func setPotentialPassword(newPass : String) {
        onlyUser.nextPassword = newPass
    }
    
    private static func cementNewPassword() {
        guard (onlyUser.nextPassword == nil) else {
            onlyUser.currentPassword = onlyUser.nextPassword
            return
        }
    }
    
    static func changeDisplayName(newDisplayName : String, completionHandler : @escaping (String?) -> ()) {
        setPotentialDisplayName(newName : newDisplayName)
        sendChangeDisplayName(newDisplayName: newDisplayName) { responseString in
            if (responseString == nil) {
                cementNewDisplayName()
            }
            completionHandler(responseString)
        }
    }
    
    private static func setPotentialDisplayName(newName : String) {
        onlyUser.nextDisplayName = newName
    }
    
    private static func cementNewDisplayName() {
        guard (onlyUser.nextDisplayName == nil) else {
            onlyUser.displayName = onlyUser.nextDisplayName
            onlyUser.nextDisplayName = nil
            return
        }
    }
    
    
}
