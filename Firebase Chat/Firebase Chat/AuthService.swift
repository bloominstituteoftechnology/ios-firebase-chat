//
//  ChatController.swift
//  Firebase Chat
//
//  Created by Nelson Gonzalez on 3/5/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    
    
    func loginAnnonimously(onSuccess: @escaping () -> Void, completion: @escaping(Error?) -> Void) {
        
        Auth.auth().signInAnonymously { (user, error) in
            if let error = error {
                print("Error signing up annonimously")
                completion(error)
            }
            guard let uid = user?.user.uid else {return}
            
            self.setUserInformation(uid: uid, onSuccess: {
                onSuccess()
            })
        }
    }
    
    func setUserInformation(uid: String, onSuccess: @escaping () -> Void){
        
        //add user to database
        let ref = Database.database().reference()
        
        let usersReference = ref.child("users")
        
        //The key is User ID
        let newUserReference = usersReference.child(uid)
        
        //push to database
        
        newUserReference.setValue(["userId": uid])
        
        onSuccess()
        
    }
}
