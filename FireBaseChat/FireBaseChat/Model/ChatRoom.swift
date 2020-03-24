//
//  ChatRoom.swift
//  FireBaseChat
//
//  Created by Enrique Gongora on 3/24/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import Foundation

struct Rooms: Codable {
    let rooms: [ChatRoom]
}

struct ChatRoom: Codable, Equatable {
    let id: String
    var messages: [Message]?
    var name: String
    
    static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.id == rhs.id
    }
}
