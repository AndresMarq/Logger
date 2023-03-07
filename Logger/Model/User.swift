//
//  User.swift
//  Logger
//
//  Created by Andres Marquez on 2023-03-06.
//

import Foundation

struct User {
    var firstName: String
    var lastName: String
    let id: UUID
    var email: String
    
    // Child in database cannot contain ".", thus e-mail is modified in computed property below
    var databaseEmail: String {
        let databaseEmail = email.replacingOccurrences(of: ".", with: "")
        return databaseEmail
    }
    
    var profilePictureFileName: String {
        return "\(databaseEmail)_profile_picture.png"
    }
}
