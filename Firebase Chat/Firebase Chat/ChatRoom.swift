//
//  Message.swift
//  Firebase Chat
//
//  Created by Jordan Christensen on 10/16/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation

struct ChatRoom: Codable {
    var messages: [Message]
}

struct Message: Codable {
    var text: String
    var sender: String
    var timestamp: Date
}
