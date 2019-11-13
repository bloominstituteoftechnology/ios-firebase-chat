//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Gi Pyo Kim on 11/12/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import MessageKit

class ChatRoom: Codable, Equatable {
    
    let title: String
    var messages: [ChatRoom.Message]
    let identifier: String
    
    init(title: String, messages: [ChatRoom.Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.identifier = identifier
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try container.decode(String.self, forKey: .title)
        if let messages = try container.decodeIfPresent([String: Message].self, forKey: .messages) {
            self.messages = Array(messages.values)
        } else {
            self.messages = []
        }
        let identifier = try container.decode(String.self, forKey: .identifier)
        
        self.title = title
        self.identifier = identifier
    }
    
    convenience init?(dictionary: [String: Any]) {
        guard let title = dictionary["title"] as? String,
            let identifier = dictionary["identifier"] as? String else {
                return nil
        }
        
        if let messagesDict = dictionary["messages"] as? [[String: Any]] {
            var messages: [ChatRoom.Message] = []
            for message in messagesDict {
                if let message = Message(dictionary: message) {
                    messages.append(message)
                }
            }
            self.init(title: title, messages: messages, identifier: identifier)
        } else {
            self.init(title: title, identifier: identifier)
        }
    }
    
    var dictionaryRepresentation: [String: Any] {
        return ["title": title, "messages": self.messages.map({$0.dinctionaryRepresentation}), "identifier": identifier]
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case messages
        case identifier
    }
    
    static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
    
    struct Message: Codable, Equatable, MessageType {

        let text: String
        let senderId: String
        let displayName: String
        var messageId: String
        var sentDate: Date
        var sender: SenderType {
            return Sender(senderId: senderId, displayName: displayName)
        }
        var kind: MessageKind { return .text(text)}
        
        init(text: String, sender: Sender, messageId: String = UUID().uuidString, sentDate: Date = Date()) {
            self.text = text
            self.senderId = sender.senderId
            self.displayName = sender.displayName
            self.messageId = messageId
            self.sentDate = sentDate
        }
        
        init?(dictionary: [String: Any]) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            
            guard let text = dictionary["text"] as? String,
                let senderDict = dictionary["sender"] as? [String: String],
                let sender = Sender(dictionary: senderDict),
                let messageId = dictionary["messageId"] as? String,
                let dateString = dictionary["sentDate"] as? String,
                let sentDate = dateFormatter.date(from: dateString) else { return nil }
            
            self.init(text: text, sender: sender, messageId: messageId, sentDate: sentDate)
        }
        
        var dinctionaryRepresentation: [String: Any] {
            guard let sender = sender as? Sender else { return [:] }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: sentDate)
            return ["text": text, "sender": sender.dictionaryRepresentation, "messageId": messageId, "sentDate": dateString]
        }
        
        
        enum CodingKeys: String, CodingKey {
            case text
            case senderId
            case displayName
            case messageId
            case sentDate
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let text = try container.decode(String.self, forKey: .text)
            let senderId = try container.decode(String.self, forKey: .senderId)
            let displayName = try container.decode(String.self, forKey: .displayName)
            let messageId = try container.decode(String.self, forKey: .messageId)
            let sentDate = try container.decode(Date.self, forKey: .sentDate)
            
            let sender = Sender(senderId: senderId, displayName: displayName)
            
            self.init(text: text, sender: sender, messageId: messageId, sentDate: sentDate)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(text, forKey: .text)
            try container.encode(senderId, forKey: .senderId)
            try container.encode(displayName, forKey: .displayName)
            try container.encode(messageId, forKey: .messageId)
            try container.encode(sentDate, forKey: .sentDate)
            
        }
        
    }
    
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

