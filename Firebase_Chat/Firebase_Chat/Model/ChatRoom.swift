//
//  ChatRoom.swift
//  Firebase_Chat
//
//  Created by Lydia Zhang on 4/21/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation

struct ChatRoom: Codable, Equatable {
    var id: String
    var name: String
    var messages: [Message]?
    
    static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Room: Codable {
    var rooms: [ChatRoom]
}
