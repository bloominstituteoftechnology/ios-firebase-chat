//
//  ChatRoom.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation

protocol DictionaryConvertable {
    init(dictionary: [String: String])
    func dictionary() -> [String: String]
}

class ChatRoom: Codable, DictionaryConvertable {
    
    let title: String
    var messages: [Message]
    let id: String
    
    init(title: String, messages: [Message] = [], id: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.id = id
    }
    
    required init(dictionary: [String: String]) {
        self.title = dictionary["title"] ?? ""
        self.id = dictionary["id"] ?? ""
        self.messages = []
    }
    
    func dictionary() -> [String: String] {
        return ["title": title,
                "id": id]
    }
}
