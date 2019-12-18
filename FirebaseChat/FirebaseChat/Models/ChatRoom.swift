//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Jon Bash on 2019-12-17.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation

struct ChatRoom {
    var name: String
    let id: String
    private(set) var messages: [Message]
    
    var creationDate: Date
    var lastUpdated: Date
    
    init(
        name: String,
        id: String = UUID().uuidString,
        messages: [Message] = [],
        creationDate: Date = Date(),
        lastUpdated: Date = Date())
    {
        self.name = name
        self.id = id
        self.messages = messages
        self.creationDate = creationDate
        self.lastUpdated = lastUpdated
    }
    
    mutating func setMessages(_ newMessages: [Message]) {
        var sortedMessages = newMessages
        var max: Date = lastUpdated
        sortedMessages.sort {
            let lessThan = $0.sentDate < $1.sentDate
            max = lessThan ? $1.sentDate : $0.sentDate
            return lessThan
        }
        lastUpdated = max
        messages = sortedMessages
    }
}

// MARK: - DictionaryRepresentation

extension ChatRoom {
    enum DictionaryKey: String {
        case name
        case id
        case messages
        case creationDate
        case lastUpdated
    }
    
    var dictionaryRepresentation: [String: Any] {
        var dictionary = [String: Any]()
        
        // helper
        func encode<T>(_ value: T, for key: DictionaryKey) {
            dictionary[key.rawValue] = value
        }
        
        encode(name, for: .name)
        encode(id, for: .id)
        encode(creationDate.timeIntervalSinceReferenceDate, for: .creationDate)
        encode(lastUpdated.timeIntervalSinceReferenceDate, for: .lastUpdated)
        
        return dictionary
    }
    
    init?(from dictionary: [String: Any]) {
        // helper
        func decode<T>(_ type: T.Type, for key: DictionaryKey) -> T? {
            return dictionary[key.rawValue] as? T
        }
        
        guard
            let name = decode(String.self, for: .name),
            let id = decode(String.self, for: .id)
            else { return nil }
        
        let creationInterval = decode(Double.self, for: .creationDate)
        let updatedInterval = decode(Double.self, for: .lastUpdated)
        
        self.init(
            name: name,
            id: id,
            creationDate: Date(timeIntervalSinceReferenceDate:
                creationInterval ?? Date().timeIntervalSinceReferenceDate),
            lastUpdated: Date(timeIntervalSinceReferenceDate:
                updatedInterval ?? Date().timeIntervalSinceReferenceDate))
    }
}
