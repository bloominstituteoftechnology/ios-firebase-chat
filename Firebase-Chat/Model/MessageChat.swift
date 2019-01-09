//
//  MessageChat.swift
//  Firebase-Chat
//
//  Created by Yvette Zhukovsky on 1/8/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var kind: MessageKind
    var sender: Sender
    var messageId: String
    var sentDate: Date
    let timestamp: NSNumber?
    let text: String?
    let senderId: String?
    
    init(dictionary: [String: Any])
    {
        self.kind = .text(dictionary["text"] as! String)
        self.text = dictionary["text"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.senderId = dictionary["senderId"] as? String
        self.sender = Sender(id: senderId!, displayName: senderId!)
        self.messageId = UUID().uuidString
        self.sentDate = Date(timeIntervalSinceNow:(timestamp?.doubleValue)!)
}

}

struct User {
   var name: String?
    var id: String?


    init(dict: [String: Any])
{
    self.name = dict["name"] as? String
    self.id = dict["id"] as? String
}
}
