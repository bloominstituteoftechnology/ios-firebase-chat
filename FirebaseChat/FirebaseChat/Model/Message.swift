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


struct Rooms {
    var rooms: [ChatRoom]
}
struct ChatRoom {
    
    let roomName: String
    var messages: [Message]?
    let identifier: String
    
    static func ==(lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.roomName == rhs.roomName &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
}
struct Message: Codable, Equatable, MessageType {
    // v1
    let text: String
    let timestamp: Date
    let displayName: String
            
    // v2
    var senderId: String
    var messageId: String
            
    var sender: SenderType {
        return Sender(senderId: senderId, displayName: displayName)
    }
    var sentDate: String {
        return timestamp
    }
    var kind: MessageKind {
        return .text(text)
    }
    enum CodingKeys: String, CodingKey {
        case roomName
        case messages
        case identifier
        case timestamp
        case senderId
        case text
        case displayName
    }
}
struct Sender: SenderType {
        var senderId: String
        var displayName: String
}

