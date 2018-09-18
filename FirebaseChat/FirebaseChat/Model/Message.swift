//
//  Message.swift
//  FirebaseChat
//
//  Created by Simon Elhoej Steinmejer on 18/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType
{
    var sender: Sender
    var messageId: String
    var sentDate: Date
    var data: MessageData
    let timestamp: NSNumber?
    let text: String?
    let senderName: String?
    let senderId: String?
    
    init(dictionary: [String: Any])
    {
        self.text = dictionary["text"] as? String
        self.senderName = dictionary["senderName"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.senderId = dictionary["senderId"] as? String
        self.data = .text(dictionary["text"] as! String)
        self.sender = Sender(id: senderId!, displayName: senderName!)
        self.messageId = UUID().uuidString
        self.sentDate = Date(timeIntervalSince1970: (timestamp?.doubleValue)!)
    }
}





