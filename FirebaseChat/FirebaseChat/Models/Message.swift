//
//  Message.swift
//  FirebaseChat
//
//  Created by Jon Bash on 2019-12-17.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var text: String
    var sentDate: Date
    var messageId: String
    
    var kind: MessageKind { return .text(text) }
    
    init(sender: Sender,
         text: String,
         sentDate: Date = Date(),
         messageId: String = UUID().uuidString)
    {
        self.sender = sender
        self.text = text
        self.sentDate = sentDate
        self.messageId = messageId
    }
    
}

// MARK: - DictionaryRepresentation

extension Message {
    enum DictionaryKey: String {
        case senderName
        case senderID
        case text
        case sentDate
        case messageId
    }
    
    var dictionaryRepresentation: [String: Any] {
        var dictionary = [String: Any]()
        
        // helper
        func encode<T>(_ value: T, for key: DictionaryKey) {
            dictionary[key.rawValue] = value
        }
        
        encode(sender.displayName, for: .senderName)
        encode(sender.senderId, for: .senderID)
        encode(text, for: .text)
        encode(sentDate.timeIntervalSinceReferenceDate, for: .sentDate)
        encode(messageId, for: .messageId)
        
        return dictionary
    }
    
    init?(from dictionary: [String: Any]) {
        // helper
        func decode<T>(_ type: T.Type, for key: DictionaryKey) -> T? {
            return dictionary[key.rawValue] as? T
        }
        
        guard
            let senderName = decode(String.self, for: .senderName),
            let senderID = decode(String.self, for: .senderID),
            let text = decode(String.self, for: .text),
            let sentDateAsIntervalFromRef = decode(
                Double.self,
                for: .sentDate),
            let messageID = decode(String.self, for: .messageId)
            else { return nil }
        let sentDate = Date(timeIntervalSinceNow: sentDateAsIntervalFromRef)
        
        self.init(
            sender: Sender(
                senderId: senderID,
                displayName: senderName),
            text: text,
            sentDate: sentDate,
            messageId: messageID)
    }
}
