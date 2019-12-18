//
//  MessageController.swift
//  FirebaseChat
//
//  Created by Lambda_School_Loaner_204 on 12/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

class MessageController {
    
    var ref: DatabaseReference!
    
    func fetchMessages(in chatRoom: ChatRoom, completion: @escaping () -> Void) {
        ref = Database.database().reference()
        
        ref.child("messages").child(chatRoom.identifier).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String: [String: Any]] else { return }
            
            let _ = value.values.map { messageDictionary in
                chatRoom.fetchedMessage(from: messageDictionary)
            }
            completion()
            
        }) { (error) in print(error.localizedDescription)}
        
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, sender: Sender, completion: @escaping () -> Void) {
        
        let message = Message(text: text, sender: sender, sentDate: Date())
        ref = Database.database().reference()

        self.ref.child("messages").child(chatRoom.identifier).childByAutoId().setValue(message.toDictionary()) {
            (error: Error?, ref: DatabaseReference) in
            if let error = error {
                print("Data Could not be saved \(error).")
            } else {
                print("Data saved succesfully!")
                chatRoom.messages.append(message)
                completion()
            }
        }
        
    }
}
