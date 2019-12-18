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
    
    init(from dictionary: [String: Any]) {
        self.displayName = dictionary["username"] as! String
        self.senderId = dictionary["senderId"] as! String
        self.messageId = dictionary["messageId"] as! String
        self.sentDate = Date(timeIntervalSince1970: dictionary["sentDate"]  as! Double)
        self.text = dictionary["text"] as! String
    }
    
    func toDictionary() -> [String: Any] {
        return [ "username" : displayName,
                 "senderId" : senderId,
                 "messageId" : messageId,
                 "sentDate" : sentDate.timeIntervalSince1970,
                 "text" : text ]
    }
}
