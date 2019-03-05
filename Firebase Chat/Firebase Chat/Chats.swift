//
//  Chats.swift
//  Firebase Chat
//
//  Created by Nelson Gonzalez on 3/5/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation

struct Chats {
    var name: String?
    var uid: String?
    var timeStamp: NSNumber?
    var id: String?
}

extension Chats {
    static func transformChats(dict: [String:Any], key: String) -> Chats {
        var chats = Chats()
        chats.id = key
        chats.name = dict["chat_name"] as? String
        chats.uid = dict["uid"] as? String
        chats.timeStamp = dict["timeStamp"] as? NSNumber
        return chats
    }
    
}
