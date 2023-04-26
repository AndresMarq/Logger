//
//  DatabaseManager.swift
//  Logger
//
//  Created by Andres Marquez on 2023-03-06.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    static func databaseEmail(email: String) -> String {
        let databaseEmail = email.replacingOccurrences(of: ".", with: "")
        return databaseEmail
    }
    
    // Add new user to Firebase realtime Database
    public func addUser(user: User, completion: @escaping (Bool) -> Void) {
        database.child(user.databaseEmail).setValue([
            "firstName": user.firstName,
            "lastName": user.lastName,
            "email": user.email,
            "id": user.id.uuidString
        ], withCompletionBlock: { [weak self] error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            
            // Create a reference to a user array, if it does exist append to it and if it doesnt create and append
            self?.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String : String]] {
                    // Append to user array
                    let newElement = [
                        "firstName": user.firstName,
                        "lastName": user.lastName,
                        "email": user.databaseEmail,
                        "id": user.id.uuidString
                    ]
                    usersCollection.append(newElement)
                    
                    self?.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    })
                    
                } else {
                    // Create the array
                    let newCollection: [[String : String]] = [
                        [
                            "firstName": user.firstName,
                            "lastName": user.lastName,
                            "email": user.databaseEmail,
                            "id": user.id.uuidString
                        ]
                    ]
                    
                    self?.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    })
                }
            })
        })
    }
    
    // Ensures unique email for new users, return true if e-mail already exists
    public func userExists(email: String, completion: @escaping (Bool) -> Void) {
        let databaseEmail = email.replacingOccurrences(of: ".", with: "")
        
        database.child(databaseEmail).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.value as? [String : String] != nil {
                completion(true)
                return
            }
            
            completion(false)
        })
    }
}
