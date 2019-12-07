//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by John Kouris on 12/7/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit
import Firebase

class ChatRoom {
    var uid: String
    var title: String
    var messages: [Message]
    
    init(uid: String = UUID().uuidString, title: String, messages: [Message] = []) {
        self.uid = uid
        self.title = title
        self.messages = messages
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String:Any] else { return nil }
        guard let uid  = dict["uid"] as? String  else { return nil }
        guard let title = dict["title"]  as? String else { return nil }
        guard let messages = dict["messages"] as? [Message] else { return nil }
        
        self.uid = uid
        self.title = title
        self.messages = messages
    }
}

struct Message {
    var senderID: String
    var text: String
    var timestamp: Date
    var author: String
    
    init(text: String, author: String, senderID: String = UUID().uuidString, timestamp: Date = Date()) {
        self.text = text
        self.senderID = senderID
        self.timestamp = timestamp
        self.author = author
    }
}
