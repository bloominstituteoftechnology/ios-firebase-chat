//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by Simon Elhoej Steinmejer on 18/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import Firebase

class ChatRoomController
{
    private(set) var chatRooms = [ChatRoom]()
    
    func createChatRoom(with name: String, completion: @escaping (Error?) -> ())
    {
        let id = UUID().uuidString
        let dictionary = ["name": name, "id": id]
        
        Database.database().reference().child("ChatRooms").child(id).updateChildValues(dictionary) { (error, _) in
            
            if let error = error
            {
                NSLog("Error creating chatroom: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func fetchChatRooms(completion: @escaping () -> ())
    {
        Database.database().reference().child("ChatRooms").observe(.childAdded) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any]
            {
                let chatRoom = ChatRoom(dictionary: dictionary)
                
                for room in self.chatRooms
                {
                    if room.id == chatRoom.id
                    {
                        return
                    }
                }
                
                self.chatRooms.append(chatRoom)
                completion()
            }
        }
    }
}

















