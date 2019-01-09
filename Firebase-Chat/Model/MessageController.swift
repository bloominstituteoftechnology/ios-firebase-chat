//
//  MessengerController.swift
//  Firebase-Chat
//
//  Created by Yvette Zhukovsky on 1/8/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase



class MessageController
{
    func createMessage(text: String, sender: String, chatId: String, completion: @escaping () -> ())
    {
        let timestamp = Int(Date().timeIntervalSince1970)
        let messageId = UUID().uuidString
        guard let senderId = UserDefaults.standard.value(forKey: "userId") else { return }
        let dict = ["text": text, "senderName": sender, "timestamp": timestamp, "senderId": senderId] as [String : Any]
        
        Database.database().reference().child("Messages").child(chatId).child(messageId).updateChildValues(dict)
        
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


