//
//  Message.swift
//  Firebase Chat
//
//  Created by macbook on 12/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

struct Message: Codable, Equatable, MessageType {
        
        //MARK: Properties
        var messageId: String
        var sentDate: Date
        var text: String
        var displayName: String
        var senderId: String
        
        var kind: MessageKind { return .text(text)}
        var sender: SenderType {
            return Sender(senderId: senderId, displayName: displayName)
        }
        
    
        init(sender: Sender, text: String, sentDate: Date = Date(), messageId: String = UUID().uuidString) {
            self.text = text
            self.displayName = sender.displayName
            self.senderId = sender.senderId
            self.sentDate = sentDate
            self.messageId = messageId
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: MessageCodingKeys.self)
            
            let text = try container.decode(String.self, forKey: .text)
            let displayName = try container.decode(String.self, forKey: .displayName)
            let sentDate = try container.decode(Date.self, forKey: .sentDate)
            
            let senderId: String
            
            if let id = try? container.decode(String.self, forKey: .senderId) {
                senderId = id
            } else {
                senderId = UUID().uuidString
            }
            
            let sender = Sender(senderId: senderId, displayName: displayName)
            
            self.init(sender: sender, text: text, sentDate: sentDate)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: MessageCodingKeys.self)
            
            try container.encode(displayName, forKey: .displayName)
            try container.encode(senderId, forKey: .senderId)
            try container.encode(sentDate, forKey: .sentDate)
            try container.encode(text, forKey: .text)
        }
        
        enum MessageCodingKeys: String, CodingKey {
            case text
            case messageId
            case sentDate
            case kind = "kind"
            case displayName
            case senderId
            case sender = "sender"
        }
        
        
    }
