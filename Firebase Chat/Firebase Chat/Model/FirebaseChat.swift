//
//  FirebaseChat.swift
//  Firebase Chat
//
//  Created by Lisa Sampson on 9/18/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import Foundation
import FirebaseDatabase
import MessageKit

struct ChatRoom: Equatable {
    let chatRoom: String
    let id: String
    var messages: [ChatRoom.Message]
    
    init(chatRoom: [String: Any]) {
        self.chatRoom = chatRoom["chatRoom"] as! String
        self.id = chatRoom["id"] as! String
        self.messages = (chatRoom["messages"] as! [[String: Any]]).map { messageDictionary in ChatRoom.Message(message: messageDictionary) }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "chatRoom": chatRoom,
            "id": id,
            "messages": messages.map { message in message.toDictionary() }
        ]
    }
    
    init( chatRoom: String, id: String = UUID().uuidString, messages: [ChatRoom.Message] = []) {
        self.chatRoom = chatRoom
        self.id = id
        self.messages = messages
    }
    
    struct Message: Equatable, MessageType {
        
        
        let username: String
        let timestamp: Date
        let messageId: String
        let text: String
        
        init(message: [String: Any]) {
            self.username = message["username"] as! String
            self.messageId = message["messageId"] as! String
            self.timestamp = Date(timeIntervalSince1970: message["timestamp"] as! Double)
            self.text = message["text"] as! String
        }
        
        func toDictionary() -> [String: Any] {
            return [
                "username": username,
                "messageId": messageId,
                "timestamp": timestamp.timeIntervalSince1970,
                "text": text
            ]
        }
        
        init(username: String, timestamp: Date = Date(), messageId: String = UUID().uuidString, text: String) {
            self.username = username
            self.timestamp = timestamp
            self.messageId = messageId
            self.text = text
        }
        
        // MARK: - MessageType
        var sender: Sender {
            return Sender(id: username, displayName: username)
        }
        var sentDate: Date { return timestamp }
        var kind: MessageKind { return .text(text)}
    }
}


