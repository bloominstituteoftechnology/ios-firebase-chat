//
//  Chat.swift
//  ios-firebase-chat
//
//  Created by De MicheliStefano on 18.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Message: Codable, Equatable {
    
    init(id: String = UUID().uuidString, text: String, timestamp: Date = Date(), sender: String, chatRoomId: String) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.sender = sender
        self.chatRoomId = chatRoomId
    }
    
    
    let id: String
    var text: String
    var timestamp: Date
    let sender: String
    let chatRoomId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case timestamp
        case sender
        case chatRoomId
    }
    
    func toDictionary() -> [String : Any] {
        return [
            CodingKeys.id.rawValue: id,
            CodingKeys.text.rawValue: text,
            CodingKeys.timestamp.rawValue: timestamp,
            CodingKeys.sender.rawValue: sender,
            CodingKeys.chatRoomId.rawValue: chatRoomId,
        ]
    }

}

struct ChatRoom: Codable, Equatable {
    
    init(id: String = UUID().uuidString, title: String, messages: [Message] = []) {
        self.id = id
        self.title = title
        self.messages = messages
    }
    
    init(from snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String : Any]
        id = snapshotValue["id"] as! String
        title = snapshotValue["title"] as! String
        
//        var messages = [Message]()
//        for message in snapshotValue["messages"] as! [Message] {
//            messages.append(message as! Message)
//        }
        
        messages = snapshotValue["messages"] as! [Message]
    }
    
    let id: String
    var title: String
    var messages: [Message]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case messages
    }
    
    func toDictionary() -> [String : Any] {
        return [
            CodingKeys.id.rawValue: id,
            CodingKeys.title.rawValue: title,
            CodingKeys.messages.rawValue: messages,
        ]
    }
    
}
