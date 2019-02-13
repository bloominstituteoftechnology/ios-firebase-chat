//
//  ChatRoom.swift
//  ios-firebase-chat
//
//  Created by Austin Cole on 2/12/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation

struct ChatRoom: Decodable {
    let identifier: String
    let messages: [Message]
    let title: String
    let creator: String
    let timestamp: Date
}
