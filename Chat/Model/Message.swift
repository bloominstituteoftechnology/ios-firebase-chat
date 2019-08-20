//
//  Message.swift
//  Chat
//
//  Created by Kat Milton on 8/20/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    let text: String
    
    let senderName: String
    let senderID: UUID
    var sender: SenderType {
        return Sender(senderId: senderID.uuidString, displayName: senderName)
    }
    
    let id: UUID
    var messageId: String {
        return id.uuidString
    }
    
    let sentDate: Date
    
    var kind: MessageKind {
        return .text(text)
    }
    
    init(text: String, senderName: String, senderID: UUID, id: UUID = UUID(), sentDate: Date = Date()) {
        self.text = text
        self.senderName = senderName
        self.senderID = senderID
        self.id = id
        self.sentDate = sentDate
    }
}

extension Message: PortableDictionaryProtocol {
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        return encoder
    }
}
