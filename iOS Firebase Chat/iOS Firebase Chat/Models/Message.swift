//
//  Message.swift
//  iOS Firebase Chat
//
//  Created by Dillon McElhinney on 10/23/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import MessageKit

struct Message: Codable, Equatable, MessageType {
    
    let sender: Sender
    let text: String
    let messageId: String
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case sender
        case text
        case timestamp
    }
    
    init(sender: Sender, text: String, messageId: String = UUID().uuidString, timestamp: Date = Date()) {
        self.sender = sender
        self.text = text
        self.messageId = messageId
        self.timestamp = timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let text = try container.decode(String.self, forKey: .text)
        let sender = try container.decode(Sender.self, forKey: .sender)
        let timestamp = try container.decode(Date.self, forKey: .timestamp)

        self.init(sender: sender, text: text, timestamp: timestamp)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(sender, forKey: .sender)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(text, forKey: .text)
    }
    
    // MARK: - MessageType
    var sentDate: Date { return timestamp }
    var kind: MessageKind { return .text(text) }

}

extension Sender: Codable {
    enum CodingKeys: String, CodingKey {
        case displayName
        case id
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let displayName = try container.decode(String.self, forKey: .displayName)
        
        self.init(id: id, displayName: displayName)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(displayName, forKey: .displayName)
    }
}
