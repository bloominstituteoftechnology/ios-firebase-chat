//
//  MessageController.swift
//  FirebaseChat
//
//  Created by Lambda_School_Loaner_268 on 3/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import Firebase
import MessageKit
import FirebaseDatabase

class MessageController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    var chatrooms: [Any] = []
    
    var ref: DatabaseReference! = Database.database().reference().child("ChatRooms")
    
    func createChatRoom(with roomName: String, completion: @escaping () -> ()) {
            
        let room = ChatRoom(roomName: roomName, messages: [], identifier: UUID().uuidString)
        self.chatrooms.append(room)
        update()
        completion()
    }
    
    func fetchChatRooms(completion: @escaping () -> ()) {
        self.ref.observe(.value, with: { (snapshot) in
           let dict = snapshot.value as? [String : ChatRoom] ?? [:]
            self.chatrooms.append(dict)
        })
        completion()
    }
    
    func createMessage(_ room: ChatRoom, message) {
        
    }
    
    func fetchMessagesInChat() {
        
    }
    
}
