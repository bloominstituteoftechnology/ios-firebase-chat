//
//  Message.swift
//  FirebaseChat
//
//  Created by Rob Vance on 10/2/20.
//

import Foundation
import MessageKit

struct Message {
    let id: String
    let text: String
    let date: Date
    
    init(id: String = UUID().uuidString, text: String, date: Date = Date()) {
        self.id = id
        self.text = text
        self.date = date
    }
    init?(id: String, dictionary: [String : Any]) {
        guard let text = dictionary["text"] as? String else { return nil }
        
        self.id = id
        self.text = text
        self.date = Date()
    }
}

extension Message: MessageType {
    var sender: SenderType {
        Sender(senderId: UUID().uuidString, displayName: "")
    }
    
    var messageId: String {
        id
    }
    
    var sentDate: Date {
        date
    }
    
    var kind: MessageKind {
        .text(text)
    }
    
    
}
struct Sender: SenderType {
    let senderId: String
    let displayName: String
}


