//
//  Message.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import MessageKit

struct Message: Codable, Equatable, DictionaryConvertable {
    
    let text: String
    let displayName: String
    var timestamp: Date
    let senderID: String
    let messageID: String
        
    init(text: String, sender: Sender = K.testUser, timestamp: Date = Date(), messageID: String = UUID().uuidString) {
        self.text = text
        self.displayName = sender.displayName
        self.timestamp = timestamp
        self.senderID = sender.senderId
        self.messageID = messageID
    }
    
    init(dictionary: [String: String]) {
        self.text = dictionary["text"] ?? ""
        self.displayName = dictionary["displayName"] ?? ""
        self.timestamp = DateFormatter().date(from: dictionary["timestamp"]!)!
        self.senderID = dictionary["senderID"] ?? ""
        self.messageID = dictionary["messageID"] ?? ""
    }
    
    func dictionary() -> [String: String] {
        return ["text": text,
                "displayName": displayName,
                "timestamp": string(from: timestamp),
                "senderID": senderID,
                "messageID": messageID,]
    }
    
    func string(from date: Date) -> String {
        return DateFormatter().string(from: date)
    }
    
    func date(from string: String) -> Date? {
        return DateFormatter().date(from: string)
    }
}

extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: senderID, displayName: displayName)
    }
    
    var messageId: String {
        return messageID
    }
    
    var sentDate: Date {
        return timestamp
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}

// MARK: - Custom Types

public struct Sender: SenderType {
    public let senderId: String
    public let displayName: String
}
