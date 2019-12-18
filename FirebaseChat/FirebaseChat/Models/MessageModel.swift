//
//  MessageModel.swift
//  FirebaseChat
//
//  Created by Lambda_School_Loaner_204 on 12/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

struct Message: Equatable, MessageType {

    let text: String
    let displayName: String
    var messageId: String
    var sentDate: Date
    var kind: MessageKind { return .text(text) }
    var sender: SenderType { return Sender(senderId: senderId, displayName: displayName) }
    var senderId: String
    
    
    enum CodingKeys: String, CodingKey {
        case displayName
        case senderID
        case text
        case sentDate
    }
    
    init(text: String, sender: Sender, sentDate: Date = Date(), messageId: String = UUID().uuidString) {
        self.text = text
        self.displayName = sender.displayName
        self.senderId = sender.senderId
        self.sentDate = sentDate
        self.messageId = messageId
    }
    
    func toDictionary() -> [String: Any] {
        return [ "username" : displayName,
                 "messageId" : messageId,
                 "sentDate" : sentDate.description,
                 "text" : text ]
    }
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let text = try container.decode(String.self, forKey: .text)
//        let displayName = try container.decode(String.self, forKey: .displayName)
//        let sentDate = try container.decode(Date.self, forKey: .sentDate)
//        var senderId: String = UUID().uuidString
//        if let decodedSenderId = try? container.decode(String.self, forKey: .senderID) {
//            senderId = decodedSenderId
//        }
//        let sender = Sender(senderId: senderId, displayName: displayName)
//        self.init(text: text, sender: sender, sentDate: sentDate)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(displayName, forKey: .displayName)
//        try container.encode(senderId, forKey: .senderID)
//        try container.encode(sentDate, forKey: .sentDate)
//        try container.encode(text, forKey: .text)
//    }
    

}
