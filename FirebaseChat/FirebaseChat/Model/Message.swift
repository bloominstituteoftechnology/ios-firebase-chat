//
//  Message.swift
//  FirebaseChat
//
//  Created by Lambda_School_Loaner_268 on 3/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import Firebase
import MessageKit


enum CodingKeys: String, CodingKey {
    case roomName
    case messages
    case identifier
    case timestamp
    case senderId
    case text
    case displayName
    case sentDate
}
struct Rooms {
    var rooms: [ChatRoom]
}
class ChatRoom: Equatable {
    
    let roomName: String
    var messages: [Message]
    let identifier: String
    
    init(roomName: String, messages: [Message] = [], identifier: String = UUID().uuidString) {
        self.roomName = roomName
        self.messages = messages
        self.identifier = identifier
    }

    static func ==(lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.roomName == rhs.roomName &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
    
    func fetchMessage(from dict: [String: Any]) {
        let message = Message(from: dict)
        if !messages.contains(message) {
            self.messages.append(message)
        }
    }
}
struct Message: Codable, Equatable, MessageType {
    var sentDate: Date {
        return Date()
    }
    
    
    
    // v1
    let text: String
    let timestamp: String
    let displayName: String
            
    // v2
    var senderId: String
    var messageId: String
            
    var sender: SenderType {
        return Sender(senderId: senderId, displayName: displayName)
    }
    
    var kind: MessageKind {
        return .text(text)
    }
    
    init(text: String, sender: Sender, sentDate: Date = Date(), timestamp: String = Date().description, messageId: String = UUID().uuidString) {
        self.text = text
        self.displayName = sender.displayName
        self.senderId = sender.senderId
        self.timestamp = String(timestamp)
        self.messageId = messageId
       
    }
    
    init(from dict: [String: Any]) {
        self.displayName = dict["displayName"] as! String
        self.senderId = dict["senderId"] as! String
        self.messageId = dict["messageId"] as! String 
        self.text = dict["text"] as! String
        self.timestamp = dict["timestamp"] as! String
    }
    
    func toDict() -> [String: Any] {
        return [ "displayName" : displayName,
                 "senderId" : senderId,
                 "messageId" : messageId,
                 "timestamp" : timestamp,
                 "text" : text,
                 "sentDate": sentDate.description]
    }

    
}
struct Sender: SenderType {
        var senderId: String
        var displayName: String
}

