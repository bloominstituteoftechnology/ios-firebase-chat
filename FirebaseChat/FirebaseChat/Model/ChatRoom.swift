//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Bradley Yin on 9/17/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation

struct ChatRoom {
    let title: String
    var messages: [Message]
    let identifier: String
    
    init(title: String, messages: [Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.identifier = identifier
    }
    func toDict() -> [String: Any] {
        return ["title": title, "messages": messages, "identifier": identifier]
    }
}
