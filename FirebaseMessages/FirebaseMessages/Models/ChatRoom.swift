//
//  ChatRoom.swift
//  FirebaseMessages
//
//  Created by Jonathan Ferrer on 6/25/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import Foundation

class ChatRoom {


    var messages: [Message]
    var name: String
    var id: String

    init(messages: [Message] = [], name: String, id: String = UUID().uuidString) {
        self.name = name
        self.id = id
        self.messages = messages
    }

    init?(dictionary: [String: Any]) {
        guard let messages = dictionary["messages"] as? [String: [String: Any]],
            let name = dictionary["name"] as? String,
            let id = dictionary["id"] as? String else { return nil}

        var messageArray: [Message] = []
        for (_, messageDict) in messages {
            if let message = Message(dictionary: messageDict) {
            messageArray.append(message)
            }
        }

        self.messages = messageArray
        self.name = name
        self.id = id
    }

    var dictionaryRep: [String: Any] {
        return ["messages": messages, "name": name, "id": id]
    }



}


