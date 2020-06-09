//
//  ChatRoom.swift
//  ios-firebase-chat
//
//  Created by Matthew Martindale on 6/7/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import Foundation
import Firebase

struct ChatRoom {
    let id: UUID
    let title: String
    let messages: [Message]?
    
    init(id: UUID = UUID(), title: String, messages: [Message]? = nil) {
        self.id = id
        self.title = title
        self.messages = messages
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let title = value["title"] as? String else {
                return nil
        }
        
        self.id = UUID(uuidString: snapshot.key) ?? UUID()
        self.title = title
        self.messages = nil
    }
    
    func intoDictionary() -> [String : Any] {
        return [
            "title": title
        ]
    }
    
}
