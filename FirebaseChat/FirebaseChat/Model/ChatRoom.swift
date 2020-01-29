//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Chad Rutherford on 1/28/20.
//  Copyright © 2020 chadarutherford.com. All rights reserved.
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
