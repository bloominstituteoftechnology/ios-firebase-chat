//
//  Chatroom.swift
//  iOS Firebase Chat
//
//  Created by Dillon McElhinney on 10/23/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation

class Chatroom: Equatable, Decodable {
    
    let title: String
    // var messages: [Message]
    let identifier: String
    let timestampUpdated: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        // case messages
        case identifier
        case timestampUpdated
    }
    
    init(title: String, messages: [Message] = [], identifier: String = UUID().uuidString, timestampUpdated: Date = Date()) {
        self.title = title
        // self.messages = messages
        self.identifier = identifier
        self.timestampUpdated = timestampUpdated
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        let identifier = try container.decode(String.self, forKey: .identifier)
        // let messagesDictionaries = try container.decodeIfPresent([String: Message].self, forKey: .messages)
        let timestampUpdated = try container.decodeIfPresent(String.self, forKey: .timestampUpdated)

        // let messages = messagesDictionaries?.compactMap({ $0.value }) ?? []
        
        self.title = title
        self.identifier = identifier
        // self.messages = messages
        self.timestampUpdated =  ISO8601DateFormatter().date(from: timestampUpdated ?? "") ?? Date()
    }
    
    static func ==(lhs: Chatroom, rhs: Chatroom) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier
            // lhs.messages == rhs.messages
    }
    
}
