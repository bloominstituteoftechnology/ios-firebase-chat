//
//  ChatRoom.swift
//  iOS Firebase Chat
//
//  Created by Dillon McElhinney on 10/23/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation

class ChatRoom: Equatable, Decodable {
    
    let title: String
    var messages: [Message]
    let identifier: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case messages
        case identifier
    }
    
    init(title: String, messages: [Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.identifier = identifier
    }
    
    init?(dictionary: [String: Any]) {
        guard let title = dictionary["title"] as? String,
            let identifier = dictionary["identifier"] as? String else { return nil}
        
        self.title = title
        self.identifier = identifier
        self.messages = dictionary["messages"] as? [Message] ?? []
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        let identifier = try container.decode(String.self, forKey: .identifier)
        let messagesDictionaries = try container.decodeIfPresent([String: Message].self, forKey: .messages)

        let messages = messagesDictionaries?.compactMap({ $0.value }) ?? []
        
        self.title = title
        self.identifier = identifier
        self.messages = messages
    }
    
    static func ==(lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
    
}
