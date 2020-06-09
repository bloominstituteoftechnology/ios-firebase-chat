//
//  ChatController.swift
//  ios-firebase-chat
//
//  Created by Matthew Martindale on 6/7/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import Foundation
import FirebaseDatabase
import MessageKit

class ChatController {
    
    let fireBaseRef = Database.database().reference()
    let chatRoomRef: DatabaseReference
    let messagesRef: DatabaseReference
    var chats = [ChatRoom]()
    var messages = [Message]()
    
    init() {
        chatRoomRef = fireBaseRef.child("chats")
        messagesRef = fireBaseRef.child("messages")
    }
    
    func createChat(title: String) {
        let newChat = ChatRoom(title: title)
        
        chatRoomRef.child(newChat.id.uuidString).setValue(newChat.intoDictionary())
    }
    
    func createMessage(for chatRoom: ChatRoom, from sender: SenderType, message: String) {
        let newMessage = Message(message: message, sentBy: sender)
        
        messagesRef.child(chatRoom.id.uuidString).child(newMessage.id.uuidString).setValue(newMessage.intoDictionary())
    }

    func fetchGroups(completion: @escaping () -> Void) {
        chatRoomRef.observe(.value, with: { snapshot in
            var newGroups = [ChatRoom]()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let group = ChatRoom(snapshot: snapshot) {
                    newGroups.append(group)
                }
            }
            self.chats = newGroups
            completion()
        })
    }
    
    func fetchMessages(for chatRoom: ChatRoom, completion: @escaping () -> Void) {
        messagesRef.child(chatRoom.id.uuidString).observe(.value, with: { snapshot in
            var newMessages = [Message]()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let message = Message(snapshot: snapshot) {
                    newMessages.append(message)
                }
            }
            self.messages = newMessages
            completion()
        })
    }
    
}
