//
//  ChatRoom.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
//import MessageKit

struct ChatRoom: Codable {
    
    let title: String
    var messages: [Message]
    let id: String
    
    init(title: String, messages: [Message] = [], id: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.id = id
    }
}
