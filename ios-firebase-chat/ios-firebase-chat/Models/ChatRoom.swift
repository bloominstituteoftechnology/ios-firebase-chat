import Foundation
import MessageKit
import Firebase

class ChatRoom: Codable, Equatable {
    
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case title
        case messages
    }
    
    let title: String
    var messages: [ChatRoom.Message]
    var identifier: String
    
    init(title: String, messages: [ChatRoom.Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.identifier = identifier
    }
    
    
    
    
    // MARK: - Equatable Conformance
    static func ==(lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.title == rhs.title &&
        lhs.identifier == rhs.identifier &&
        lhs.messages == rhs.messages
    }
    
    
    struct Message: Codable, Equatable, MessageType {
        
        let text: String
        let senderName: String
        let timestamp: Date
        let messageId: String
        
        enum CodingKeys: String, CodingKey {
            case text
            case senderName
            case timestamp
            case messageId
        }
        
        // MARK: - MessageType
        var sentDate: Date { return timestamp }
        var kind: MessageKind { return .text(text) }
        var sender: Sender { return Sender(id: senderName, displayName: senderName) }
        
        init(text: String, senderName: String, timestamp: Date = Date(), messageId: String = UUID().uuidString) {
            self.text = text
            self.senderName = senderName
            self.timestamp = timestamp
            self.messageId = messageId
            
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let text = try container.decode(String.self, forKey: .text)
            let senderName = try container.decode(String.self, forKey: .senderName)
            let timestamp = try container.decode(Date.self, forKey: .timestamp)
            
            self.init(text: text, senderName: senderName, timestamp: timestamp)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(senderName, forKey: .senderName)
            try container.encode(timestamp, forKey: .timestamp)
            try container.encode(text, forKey: .text)
        }
        
        // MARK: - Equatable Conformance
        static func == (lhs: ChatRoom.Message, rhs: ChatRoom.Message) -> Bool {
            return lhs.text == rhs.text &&
                lhs.senderName == rhs.senderName &&
                lhs.timestamp == rhs.timestamp
        }
        
    }
    
}
