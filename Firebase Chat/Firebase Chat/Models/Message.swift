//
//  Message.swift
//  Firebase Chat
//
//  Created by Vici Shaweddy on 12/4/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import Foundation
import MessageKit

struct Message: Codable, Equatable {
    let identifier: String
    let message: String
    
    init(identifier: String = UUID().uuidString, message: String) {
        self.identifier = identifier
        self.message = message
    }
    
    init(dictionary: [String: AnyObject]) {
        self.identifier = dictionary["identifier"] as? String ?? ""
        self.message = dictionary["message"] as? String ?? ""
    }
}

extension Message: MessageType {
    var sender: SenderType {
        return Sender(id: "test", displayName: "Jane")
    }
    
    var messageId: String {
        return identifier
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(message)
    }
}
