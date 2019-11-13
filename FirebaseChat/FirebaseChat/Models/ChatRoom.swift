//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Gi Pyo Kim on 11/12/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import MessageKit

class ChatRoom {
    
    let title: String
    var messages: [ChatRoom.Message]
    let identifier: String
    
    init(title: String, messages: [ChatRoom.Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.identifier = identifier
    }
    
    convenience init?(dictionary: [String: Any]) {
        guard let title = dictionary["title"] as? String,
            let identifier = dictionary["identifier"] as? String else {
                return nil
        }
        
        if let messagesDict = dictionary["messages"] as? [[String: Any]] {
            var messages: [ChatRoom.Message] = []
            for message in messagesDict {
                if let message = Message(dictionary: message) {
                    messages.append(message)
                }
            }
            self.init(title: title, messages: messages, identifier: identifier)
        } else {
            self.init(title: title, identifier: identifier)
        }
    }
    
    var dictionaryRepresentation: [String: Any] {
        return ["title": title, "messages": self.messages.map({$0.dinctionaryRepresentation}), "identifier": identifier]
    }
    
    struct Message: Codable, Equatable, MessageType {

        let text: String
        let senderId: String
        let displayName: String
        var messageId: String
        var sentDate: Date
        var sender: SenderType {
            return Sender(senderId: senderId, displayName: displayName)
        }
        var kind: MessageKind { return .text(text)}
        
        init(text: String, sender: Sender, messageId: String = UUID().uuidString, sentDate: Date = Date()) {
            self.text = text
            self.senderId = sender.senderId
            self.displayName = sender.displayName
            self.messageId = messageId
            self.sentDate = sentDate
        }
        
        init?(dictionary: [String: Any]) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .medium
            
            guard let text = dictionary["text"] as? String,
                let senderDict = dictionary["sender"] as? [String: String],
                let sender = Sender(dictionary: senderDict),
                let messageId = dictionary["messageId"] as? String,
                let dateString = dictionary["sentDate"] as? String,
                let sentDate = dateFormatter.date(from: dateString) else { return nil }
            
            self.init(text: text, sender: sender, messageId: messageId, sentDate: sentDate)
        }
        
        var dinctionaryRepresentation: [String: Any] {
            guard let sender = sender as? Sender else { return [:] }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .medium
            let dateString = dateFormatter.string(from: sentDate)
            return ["text": text, "sender": sender.dictionaryRepresentation, "messageId": messageId, "sentDate": dateString]
        }
    }
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

