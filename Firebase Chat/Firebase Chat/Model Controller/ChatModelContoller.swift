//
//  ChatModelContoller.swift
//  Firebase Chat
//
//  Created by Vici Shaweddy on 12/4/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatModelController {
    let ref = Database.database().reference()
    
    func createChat(completion: @escaping (Chat?) -> Void) {
        let chat = Chat()
        let encoder = JSONEncoder()
        let data = try! encoder.encode(chat)
        let dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        self.ref.child("chats").child(chat.identifier).setValue(dictionary) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Chat could not be saved: \(error).")
            completion(nil)
          } else {
            print("Chat saved successfully!")
            completion(chat)
          }
        }
    }
    
    func createMessage(in chat: Chat, withText message: String, completion: @escaping (Message?) -> Void) {
        let message = Message(message: message)
        let encoder = JSONEncoder()
        let data = try! encoder.encode(message)
        let dictionary = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
    self.ref.child("messages").child(chat.identifier).child(message.identifier).setValue(dictionary) { (error, ref) in
            if let error = error {
                print("Message couldn't be saved: \(error).")
                completion(nil)
            } else {
                print("Message saved successfully!")
                completion(message)
            }
        }
    }
}

