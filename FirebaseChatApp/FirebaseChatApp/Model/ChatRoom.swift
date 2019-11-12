//
//  ChatRoom.swift
//  FirebaseChatApp
//
//  Created by Jerry haaser on 11/12/19.
//  Copyright © 2019 Jerry haaser. All rights reserved.
//

import Foundation

class ChatRoom {
    
    static private let identifierKey = "identifier"
    static private let nameKey = "name"
    
    let identifier: String
    let name: String
    
    var messages: [Message] {
        didSet {
//            DispatchQueue.main.async {
//                NotificationCenter.default.post(name: .messagesWereUpdated, object: self)
//            }
        }
    }
    
    var dictionaryRepresentation: [String: String] {
        return [ChatRoom.identifierKey: identifier, ChatRoom.nameKey: name]
    }
    
    init(identifier: String = UUID().uuidString, name: String, messages: [Message] = []) {
        self.identifier = identifier
        self.name = name
        self.messages = messages
    }

    
    convenience init?(dictionary: [String: String], messages: [Message] = []) {
        guard let identifier = dictionary[ChatRoom.identifierKey],
            let name = dictionary[ChatRoom.nameKey] else { return nil }
        
        self.init(identifier: identifier, name: name, messages: messages)
    }
}


