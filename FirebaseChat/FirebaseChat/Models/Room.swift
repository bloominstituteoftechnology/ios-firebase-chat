//
//  Room.swift
//  FirebaseChat
//
//  Created by Joshua Rutkowski on 4/26/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
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
