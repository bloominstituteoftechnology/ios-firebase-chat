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
    
    static let userId = UIDevice.current.identifierForVendor!.uuidString
    
    func createUser(name: String, completion: @escaping (Error?)->()) {
        
        
        let dict = ["name":name, "id":ChatController.userId]
        Database.database().reference().child("User").child(ChatController.userId).updateChildValues(dict) {(error, _) in
            
            if let error = error {
                
                NSLog("error creating user\(error)")
                completion(error)
                return
            }
            
        }
    }
    
    
    
    func fetchUser(completion: @escaping (User?, Error?) -> ())
    {
        
        Database.database().reference().child("User").child(ChatController.userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value {
                guard let dict = value as? [String:Any] else {
                    completion(nil, nil)
                    return
                }
                let user = User(dict: dict)
                completion(user, nil)
            } else {
                completion(nil, nil)
            }
            
        }) { (error) in
            completion(nil, error)
        }
    }








func creatingChatRoom(name: String, completion: @escaping (String?, Error?) -> () ){
    
    let id = UUID().uuidString
    let dict = ["name": name, "id": id]
    Database.database().reference().child("Chat").child(id).updateChildValues(dict) {(error, _) in
        
        if let error = error {
            
            NSLog("error creating chat\(error)")
            completion(nil, error)
            return
        }
        completion(id, nil)
        
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
