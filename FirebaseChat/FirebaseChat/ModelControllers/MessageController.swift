//
//  MessageController.swift
//  FirebaseChat
//
//  Created by Simon Elhoej Steinmejer on 18/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import Firebase

class MessageController
{
    func createMessage(text: String, sender: String, chatRoomId: String, completion: @escaping () -> ())
    {
        let timestamp = Int(Date().timeIntervalSince1970)
        let messageId = UUID().uuidString
        guard let senderId = UserDefaults.standard.value(forKey: "userId") else { return }
        let dictionary = ["text": text, "senderName": sender, "timestamp": timestamp, "senderId": senderId] as [String : Any]
        
        Database.database().reference().child("Messages").child(chatRoomId).child(messageId).updateChildValues(dictionary)
        
        completion()
    }
    
    func fetchMessages(for chatRoomId: String, completion: @escaping (Message) -> ())
    {
        Database.database().reference().child("Messages").child(chatRoomId).observe(.childAdded) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any]
            {
                let message = Message(dictionary: dictionary)
                completion(message)
            }
        }
    }
}




