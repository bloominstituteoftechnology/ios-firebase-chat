//
//  Message.swift
//  FirebaseChat
//
//  Created by Spencer Curtis on 9/18/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {

    static let senderKey = "sender"
    static let sentDateKey = "sentDate"
    static let messageIdKey = "messageId"
    static let kindKey = "text"
    
    let sender: Sender
    let sentDate: Date
    let messageId: String
    let kind: MessageKind
    
    var text: String {
        let text: String
        
        switch kind {
        case .text(let messageText):
            text = messageText
        default:
            text = ""
        }
        
        return text
    }
    
    init(sender: Sender, sentDate: Date = Date(), messageId: String, text: String) {
        
        self.sender = sender
        self.sentDate = sentDate
        self.messageId = messageId
        self.kind = MessageKind.text(text)
    }
    
    init?(dictionary: [String: Any]) {
        
        guard let senderDict = dictionary[Message.senderKey] as? [String : String],
            let sender = Sender(dictionary: senderDict),
            let sentDateTimeInterval = dictionary[Message.sentDateKey] as? TimeInterval,
            let messageId = dictionary[Message.messageIdKey] as? String,
            let text = dictionary[Message.kindKey] as? String else { return nil }
        
        
        let sentDate = Date(timeIntervalSince1970: sentDateTimeInterval)
        
        self.init(sender: sender, sentDate: sentDate, messageId: messageId, text: text)
    }
    
    
    var dictionaryRepresentation: [String: Any] {

        return [Message.senderKey : sender.dictionaryRepresentation,
                Message.sentDateKey : sentDate.timeIntervalSince1970,
                Message.messageIdKey : messageId,
                Message.kindKey : text]
    }
}


extension Sender {
    
    private static let idKey = "id"
    private static let displayNameKey = "displayName"
    
    var dictionaryRepresentation: [String : String] {
        return [Sender.idKey : id,
                Sender.displayNameKey : displayName]
    }
    
    init?(dictionary: [String : String]) {
        guard let id = dictionary[Sender.idKey],
            let displayName = dictionary[Sender.displayNameKey] else { return nil }
        
        
        self.init(id: id, displayName: displayName)
    }
}
