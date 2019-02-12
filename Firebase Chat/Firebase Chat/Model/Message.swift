
import Foundation
import MessageKit

import Foundation
import MessageKit

struct AnyKey: CodingKey {
    
    let stringValue: String
    let intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}

class ChatRoom: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case indentifier
        case title
        case messages
    }
    
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
        
        let title = try container.decodeIfPresent(String.self, forKey: .title)
        
        let identifier: String
        if let id = try container.decodeIfPresent(String.self, forKey: .indentifier) {
            identifier = id
        } else if let id = try container.decodeIfPresent(String.self, forKey: .identifier) {
            identifier = id
        } else {
            identifier = UUID().uuidString
        }
        
        let messagesContainer = try? container.nestedContainer(keyedBy: AnyKey.self, forKey: .messages)
        
        let messageKeys = messagesContainer?.allKeys ?? []
        let messages = try messageKeys.map { key -> Message in
            let identifier = key.stringValue
            
            let messageContainer = try messagesContainer!.nestedContainer(keyedBy: Message.CodingKeys.self, forKey: key)
            let text = try messageContainer.decode(String.self, forKey: .text)
            let sender = try messageContainer.decode(String.self, forKey: ._sender)
            let timestamp: Date
            if let d = try messageContainer.decodeIfPresent(Date.self, forKey: .timeStamp) {
                timestamp = d
            } else {
                timestamp = try messageContainer.decode(Date.self, forKey: .timestamp)
            }
            return Message(text: text, sender: sender, timestamp: timestamp, messageId: identifier)
            }.sorted { $0.timestamp < $1.timestamp }
        
        self.title = title ?? "New Chat"
        self.identifier = identifier
        self.messages = messages
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(identifier, forKey: .identifier)
        
        var messagesContainer = container.nestedContainer(keyedBy: AnyKey.self, forKey: .messages)
        for m in messages {
            var messageContainer = messagesContainer.nestedContainer(keyedBy: Message.CodingKeys.self, forKey: AnyKey(stringValue: m.messageId)!)
            try messageContainer.encode(m._sender, forKey: ._sender)
            try messageContainer.encode(m.timestamp, forKey: .timestamp)
            try messageContainer.encode(m.text, forKey: .text)
        }
    }
    
    
    struct Message: Codable, Equatable, MessageType {
        
        init(text: String, sender: String, timestamp: Date = Date(), messageId: String = UUID().uuidString) {
            self.text = text
            self._sender = sender
            self.timestamp = timestamp
            self.messageId = messageId
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let text = try container.decode(String.self, forKey: .text)
            let sender = try container.decode(String.self, forKey: ._sender)
            let timestamp = try container.decode(Date.self, forKey: .timestamp)
            
            self.init(text: text, sender: sender, timestamp: timestamp)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(_sender, forKey: ._sender)
            try container.encode(timestamp, forKey: .timestamp)
            try container.encode(text, forKey: .text)
        }
        
        let text: String
        let _sender: String
        let timestamp: Date
        let messageId: String
        
        enum CodingKeys: String, CodingKey {
            case _sender = "sender"
            case text
            case timestamp
            case timeStamp
        }
        
        // MARK: - MessageType
        var sentDate: Date { return timestamp }
        var kind: MessageKind { return .text(text) }
        var sender: Sender {
            return Sender(id: _sender, displayName: _sender)
        }
    }
    
    static func ==(lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier &&
            lhs.messages == rhs.messages
    }
}
