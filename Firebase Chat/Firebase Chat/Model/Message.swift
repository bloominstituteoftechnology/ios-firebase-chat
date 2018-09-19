//
//  Message.swift
//  Firebase Chat
//
//  Created by Linh Bouniol on 9/18/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation

struct Message {
    
    var sender: String
    var messageText: String
//    var timestamp: Date
    var messageId: String
    
    init(sender: String, messageText: String) {
        self.sender = sender
        self.messageText = messageText
//        self.timestamp = Date()
        self.messageId = UUID().uuidString
    }
    
    // extract data from dictionary on firebase and save to struct
    init?(dictionary: Dictionary<String, Any>) {
        guard let sender = dictionary["sender"] as? String else { return nil }
        guard let message = dictionary["messageText"] as? String else { return nil }
//        guard let timestamp = dictionary["timestamp"] as? Date else { return nil }
        guard let messageId = dictionary["messageId"] as? String else { return nil }
        
        self.sender = sender
        self.messageText = message
//        self.timestamp = timestamp
        self.messageId = messageId
    }
    
    // turn struct into dictionary so it can be put to firebase
    var dictionary: Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()
        dictionary["sender"] = sender
        dictionary["messageText"] = messageText
//        dictionary["timestamp"] = timestamp
        dictionary["messageId"] = messageId
        return dictionary
    }
}
