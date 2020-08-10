//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Elizabeth Thomas on 8/10/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import Foundation
import MessageKit
import Firebase

class ChatRoom {
    
    var title: String
    let id: String
    var messages: [Message]
    
    init(title: String, id: String = UUID().uuidString, messages: [Message] = []) {
        self.title = title
        self.id = id
        self.messages = messages
    }
    
    init?(id: String, dict: [String : Any]) {
        guard let title = dict["title"] as? String else { return nil }
        
        self.id = id
        self.title = title
        self.messages = []
    }
}

