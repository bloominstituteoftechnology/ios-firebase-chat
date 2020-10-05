//
//  ChatRoom.swift
//  iosFirebaseChatProject
//
//  Created by BrysonSaclausa on 10/4/20.
//

import Foundation
import MessageKit

class ChatRoom: Codable, Equatable {
    
    let title: String
    let messages: [Message]
    let identifier: String
    
    init(title: String, messages: [Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.identifier = identifier
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let identifier = try container.decode(String.self, forKey: .identifier)
        if let messages = try container.decodeIfPresent([String: Message].self, forKey: .messages) {
            self.messages = Array(messages.values)
        } else {
            self.messages = []
        }
        
        self.title = title
        self.identifier = identifier
    }
    
    static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
        
}

    
    
    
    

