//
//  Thread.swift
//  ios-firebase-chat
//
//  Created by Benjamin Hakes on 2/12/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation

class Thread: Equatable, Decodable {
    
    var title: String
    var messages: [Message]
    var threadID: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case messages
        case threadID
    }
    
    init(title: String, messages: [Message] = [], threadID: String = UUID().uuidString) {
        self.title = title
    }
    
    init?(dictionary: [String: Any]) {
        guard let title = dictionary["title"] as? String,
            let identifier = dictionary["threadID"] as? String else { return nil}
        
        self.title = title
        self.threadID = identifier
        self.messages = dictionary["messages"] as? [Message] ?? []
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        let threadID = try container.decode(String.self, forKey: .threadID)
        let messagesDictionaries = try container.decodeIfPresent([String: Message].self, forKey: .messages)
        
        let messages = messagesDictionaries?.compactMap({ $0.value }) ?? []
        
        self.title = title
        self.threadID = threadID
        self.messages = messages
    }
    
    static func ==(lhs: Thread, rhs: Thread) -> Bool {
        return lhs.title == rhs.title &&
            lhs.threadID == rhs.threadID &&
            lhs.messages == rhs.messages
    }
}
