//
//  ChatRoomController.swift
//  FirebaseChat
//
//  Created by Bradley Yin on 9/17/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatRoomController {
    
    var chatRooms: [ChatRoom] = []
    
    var currentUser: Sender?
    
    let databaseRef = Database.database().reference()
    
    func createChatRoom(title: String, completion: @escaping () -> Void) {
        let chatRoom = ChatRoom(title: title, messages: [], identifier: UUID().uuidString)
        databaseRef.child("chatRooms").child(chatRoom.identifier).setValue(chatRoom.toDict())
        completion()
    }
    
    func fetchChatRoom(completion: @escaping () -> Void) {
        databaseRef.child("chatRooms").observe(.childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? Dictionary<String, Any> else { fatalError("cant cast to dict")}
            let chatRoom = ChatRoom(title: snapshotValue["title"]! as! String, messages: [], identifier: snapshotValue["identifier"] as! String)
            self.chatRooms.append(chatRoom)
            print(self.chatRooms)
            completion()
         
        }
    }
    
    func createMessage(chatRoom: ChatRoom, message: Message, completion: @escaping () -> Void) {
    databaseRef.child("chatRooms").child(chatRoom.identifier).child("messages").child(message.messageId).setValue(message.toDict())
        
        completion()
    }
    
    func fetchMessages(chatRoom: ChatRoom, completion: @escaping () -> Void) {
        databaseRef.child("chatRooms").child(chatRoom.identifier).child("messages").observe(.childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? Dictionary<String, Any> else { fatalError("cant cast to dict")}
            
            print(snapshotValue["displayName"])
            
            
            completion()
            
        }
    }
}
