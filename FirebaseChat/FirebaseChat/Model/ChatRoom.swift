//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Thomas Dye on 06/5/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import Foundation
import MessageKit

class ChatRoom {
    var chatRoomID: String
    var title: String
    var created: Date
    var lastUpdated: Date
    var messages: [Message] = []
    
    init(chatRoomID: String = UUID().uuidString, title: String, created: Date = Date(), lastUpdated: Date = Date()) {
        self.chatRoomID = chatRoomID
        self.title = title
        self.created = created
        self.lastUpdated = lastUpdated
    }
    
    var asDictionary: [String : Any] {
        var dic: [String : Any] = [:]
        dic["chatRoomID"] = chatRoomID
        dic["title"] = title
        dic["created"] = created
        dic["lastUpdated"] = lastUpdated
        return dic
    }
}
