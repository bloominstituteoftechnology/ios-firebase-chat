//
//  Message.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import MessageKit

struct Message: DictionaryConvertable {
    
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
        self.senderID = dictionary["senderID"] ?? ""
        self.messageID = dictionary["messageID"] ?? ""
        
//        self.timestamp = DateFormatter().date(from: dictionary["timestamp"]!)!
        if let dateString = dictionary["timestamp"],
            let date = DateFormatter().date(from: dateString){
            self.timestamp = date
        } else {
            print("dateString: \"\(dictionary["timestamp"] ?? "nil")\"")
            self.timestamp = Date()
        }
    }
    
    func dictionary() -> [String: String] {
        return ["text": text,
                "displayName": displayName,
                "timestamp": string(from: timestamp),
                "senderID": senderID,
                "messageID": messageID,]
    }
    
    func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func date(from string: String) -> Date? {
        return dateFormatter.date(from: string)
    }
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return formatter
    }()
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
