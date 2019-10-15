//
//  ChatController.swift
//  FirebaseChat
//
//  Created by Ciara Beitel on 10/15/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatController {
    var ref: DatabaseReference! = Database.database().reference()
    var currentChatRoom: ChatRoom?
    
    func createChatRoom(name: String, id: UUID = UUID()) {
        let chatRoom = ChatRoom(id: id, messages: [], name: name)
        self.ref
            .child("chatRooms")
            .child(chatRoom.id.uuidString)
            .setValue([
                "id" : chatRoom.id.uuidString,
                "name" : chatRoom.name,
                "messages" : chatRoom.messages,
            ])
        // add chat room to chat rooms on controller
    }
    
    func fetchChatRoom(id: UUID) -> ChatRoom? {
        self.ref
            .child("chatRooms")
            .child(id.uuidString)
            .observeSingleEvent(of: .value) { (snapshot) in
                let room = snapshot.value as? NSDictionary
                self.currentChatRoom = ChatRoom(
                    id: id,
                    messages: room?["messages"] as? [Message] ?? [],
                    name: room?["name"] as? String ?? ""
                )
            }
        // verify the fetched chat room is in the chat rooms array on the chat room controller
        return currentChatRoom
    }
    
    func createMessage(room: UUID, id: UUID = UUID(), sender: String, text: String, timeStamp: Date = Date()) {
        let message = Message(id: id, sender: sender, text: text, timeStamp: timeStamp)
        self.ref
            .child("chatRooms")
            .child(room.uuidString)
            .child("messages")
            .child(message.id.uuidString)
            .setValue([
                "id" : message.id.uuidString,
                "sender" : message.sender,
                "text" : message.text,
                "timestamp": message.timeStamp
            ])
        // add message to chat room, this requires getting the chat room by ID, then adding the message to the messages array
    }
    
    func fetchMessages(room: UUID) {
        self.ref
            .child("chatRooms")
            .child(room.uuidString)
            .child("messages")
            .observeSingleEvent(of: .value) { (snapshot) in
                
        }
    }
}
