//
//  Message.swift
//  Firebase
//
//  Created by Alex Thompson on 2/16/20.
//  Copyright © 2020 Lambda_School_Loaner_213. All rights reserved.
//

import Foundation
import MessageKit

struct Message: Codable, Equatable, Comparable {
    static func < (lhs: Message, rhs: Message) -> Bool {
        return true
    }
    
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
        return Sender(id: "1234", displayName: "Alex")
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
