//
//  ChatRoom.swift
//  Firebase Chat
//
//  Created by Linh Bouniol on 9/18/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation

struct ChatRoom: Equatable {
    
    var name: String
    var messages: [Message]
    var chatRoomId: String
    
    init(name: String) {
        self.name = name
        self.messages = []
        self.chatRoomId = UUID().uuidString
    }
    
    // properties can have any type, but we want the value to be string when we get the value out of those properties
    // converting model objects from dictionary
    init?(dictionary: Dictionary<String, Any>) {
        guard let name = dictionary["name"] as? String else { return nil }
        guard let chatRoomId = dictionary["chatRoomId"] as? String else { return nil }
        let messageDictionaries = dictionary["messages"] as? Dictionary<String, Dictionary<String, Any>> ?? [:]
        
        var messages = [Message]()
        
        for messageDictionary in messageDictionaries {
            guard let message = Message(dictionary: messageDictionary.value) else { return nil }
            messages.append(message)
        }
        
        self.name = name
        self.chatRoomId = chatRoomId
        self.messages = messages
    }
    
    // turn struct into dictionary so it can be put to firebase
    var dictionary: Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()
        dictionary["name"] = name
        dictionary["chatRoomId"] = chatRoomId
        
        // Here the messages is a array of Message, but we want an array of dictionary. Map will go through the array and turn each message into a dictionary
//        dictionary["messages"] = messages.map { $0.dictionary } // .dictionary is the computed prop in Message struct
        
        var messageDictionaries: Dictionary<String, Any> = [:]
        
        for message in messages {
            messageDictionaries[message.messageId] = message.dictionary
        }
        
        dictionary["messages"] = messageDictionaries
        
        return dictionary
    }
    
    static func ==(lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs.chatRoomId == rhs.chatRoomId
    }
}
