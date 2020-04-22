//
//  Message.swift
//  FirebaseChat
//
//  Created by Christopher Devito on 4/21/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation
import MessageKit

struct Message: Codable, MessageType {
    let messageText: String
    let displayName: String
    let senderID: String
    let timeStamp: Date
    let messageId: String
    
    var sentDate: Date {
        return timeStamp
    }
    
    var kind: MessageKind {
        return .text(messageText)
    }
    
    var sender: SenderType {
        return Sender(senderId: senderID, displayName: displayName)
    }
    
    var dictionaryRepresentation: [String : String] {
        return ["messageText" : messageText,
                "displayName" : displayName,
                "senderID" : senderID,
                "timeStamp" : "\(timeStamp)",
                "messageId" : messageId]
    }
    
    init?(dictionary: [String : String]) {
        guard let messageText = dictionary["messageText"],
            let displayName = dictionary["displayName"],
            let senderID = dictionary["senderID"],
            let timeStamp = dictionary["timeStamp"],
            let messageID = dictionary["messageID"]
            else {
            return nil
        }
        
        let sentDate: Date = timeStamp.toDate(timeStamp) ?? Date()
        let sender = Sender(senderId: senderID, displayName: displayName)
        
        self.init(messageText: messageText, sender: sender, timeStamp: sentDate, messageID: messageID)
    }
    
    init(messageText: String, sender: Sender, timeStamp: Date = Date(), messageID: String) {
        self.messageText = messageText
        self.displayName = sender.displayName
        self.senderID = sender.senderId
        self.timeStamp = timeStamp
        self.messageId = messageID
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let messageText = try container.decode(String.self, forKey: .messageText)
        let displayName = try container.decode(String.self, forKey: .displayName)
        let senderID = try container.decode(String.self, forKey: .senderID)
        let timeStamp = try container.decode(Date.self, forKey: .timeStamp)
        let messageID = try container.decode(String.self, forKey: .messageID)
        
        let sender = Sender(senderId: senderID, displayName: displayName)
        
        self.init(messageText: messageText, sender: sender, timeStamp: timeStamp, messageID: messageID)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(messageText, forKey: .messageText)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(senderID, forKey: .senderID)
        try container.encode(timeStamp, forKey: .timeStamp)
        try container.encode(messageId, forKey: .messageID)
        
    }
    
    
    enum CodingKeys: String, CodingKey {
        case displayName
        case senderID
        case messageText
        case timeStamp
        case messageID
    }
}

extension String {

    func toDate(_ date: String) -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
}
