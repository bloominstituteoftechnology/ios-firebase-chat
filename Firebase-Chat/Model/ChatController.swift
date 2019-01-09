//
//  ChatController.swift
//  Firebase-Chat
//
//  Created by Yvette Zhukovsky on 1/8/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase



class ChatController {
    
    
    private(set) var chat = [Chat]()
    
    func creatingChatRoom(name: String, completion: @escaping (Error?) -> () ){
        
        let id = UUID().uuidString
        let dict = ["name": name, "id": id]
        Database.database().reference().child("Chat").child(id).updateChildValues(dict) {(error, _) in
            
            if let error = error {
                
                NSLog("error creating chat\(error)")
                completion(error)
                return
            }
        
        }
    }
    
    func fetchChats(completion: @escaping () -> ())
    {
        Database.database().reference().child("Chat").observe(.childAdded) { (snapshot) in
            
            if let dict = snapshot.value as? [String: Any]
            {
                let chat = Chat(dict: dict)
                
                for room in self.chat
                {
                    if room.id == chat.id
                    {
                        return
                    }
                }
                
                self.chat.append(chat)
                completion()
            }
        }
    }
    
    
    
    
    
}
