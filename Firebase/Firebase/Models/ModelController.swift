//
//  ModelController.swift
//  Firebase
//
//  Created by Alex Thompson on 2/15/20.
//  Copyright © 2020 Lambda_School_Loaner_213. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ModelController {
    let ref = Database.database().reference()
    
    func createChat(completion: @escaping (Chat?) -> Void) {
        let chat = Chat()
        let encoder = JSONEncoder()
        let data = try! encoder.encode(chat)
        let dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        self.ref.child("chats").child(chat.identifier).setValue(dictionary) {
            (error: Error?, ref: DatabaseReference) in
            if let error = error {
                print("The chat couldn't be saved, heres your error: (\(error))")
                completion(nil)
            } else {
                print("Chat saved!!")
                completion(chat)
            }
        }
    }
    
    func createMessage(in chat: Chat, withText message: String, completion: @escaping (Message?) -> Void) {
        let message = Message(message: message)
        let encoder = JSONEncoder()
        let data = try! encoder.encode(message)
        let dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        self.ref.child("messages").child(chat.identifier).setValue(dictionary) { (error, ref) in
            if let error = error {
                print("Message couldnt be saved, compiler is sorry, here is your error message: \(error)")
                completion(nil)
            } else {
                print("Message saved!!!")
            }
        }
    }
}
