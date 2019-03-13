//
//  Message.swift
//  Firebase Chat
//
//  Created by Angel Buenrostro on 3/13/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation
import MessageKit

class Message: Codable {
    let sender: String
    var body: String
}

//class MessageThread: Codable, Equatable {
//
//    let title: String
//    var messages: [MessageThread.Message]
//    let identifier: String
//
//
//    init(title: String, messages: [MessageThread.Message] = [], identifier: String = UUID().uuidString) {
//        self.title = title
//        self.messages = messages
//        self.identifier = identifier
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let title = try container.decode(String.self, forKey: .title)
//        let identifier = try container.decode(String.self, forKey: .identifier)
//        let messagesDictionaries = try container.decodeIfPresent([String: Message].self, forKey: .messages)
//
//        let messages = messagesDictionaries?.compactMap({ $0.value }) ?? []
//
//        self.title = title
//        self.identifier = identifier
//        self.messages = messages
//    }
//
//
//    struct Message: Codable, Equatable, MessageType {
//
//        init(text: String, sender: Sender, timestamp: Date = Date(), messageId: String = UUID().uuidString) {
//            self.text = text
//            self.displayName = sender.displayName
//            self.senderID = sender.id
//            self.timestamp = timestamp
//            self.messageId = messageId
//        }
//
//        init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//
//            let text = try container.decode(String.self, forKey: .text)
//            let displayName = try container.decode(String.self, forKey: .displayName)
//            let senderID = try container.decode(String.self, forKey: .senderID)
//            let timestamp = try container.decode(Date.self, forKey: .timestamp)
//
//            let sender = Sender(id: senderID, displayName: displayName)
//
//            self.init(text: text, sender: sender, timestamp: timestamp)
//        }
//
//        func encode(to encoder: Encoder) throws {
//            var container = encoder.container(keyedBy: CodingKeys.self)
//
//            try container.encode(displayName, forKey: .displayName)
//            try container.encode(senderID, forKey: .senderID)
//            try container.encode(timestamp, forKey: .timestamp)
//            try container.encode(text, forKey: .text)
//        }
//
//        let text: String
//        let displayName: String
//        let senderID: String
//        let timestamp: Date
//        let messageId: String
//
//        enum CodingKeys: String, CodingKey {
//            case displayName
//            case senderID
//            case text
//            case timestamp
//        }
//
//        // MARK: - MessageType
//        var sentDate: Date { return timestamp }
//        var kind: MessageKind { return .text(text) }
//        var sender: Sender {
//            return Sender(id: senderID, displayName: displayName)
//        }
//    }
//
//    static func ==(lhs: MessageThread, rhs: MessageThread) -> Bool {
//        return lhs.title == rhs.title &&
//            lhs.identifier == rhs.identifier &&
//            lhs.messages == rhs.messages
//    }
//}
