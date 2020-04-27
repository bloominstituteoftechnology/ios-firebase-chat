//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Sal B Amer on 4/27/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
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
