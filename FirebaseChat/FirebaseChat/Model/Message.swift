//
//  Message.swift
//  FirebaseChat
//
//  Created by Sal B Amer on 4/26/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import Foundation
import MessageKit

class ChatThread: Codable {
    
    let title: String
    let messages: [ChatThread.Message]
    let identifier: String
    
    internal init(title: String, messages: [ChatThread.Message] = [], identifier: String = UUID().uuidString) {
          self.title = title
          self.messages = messages
          self.identifier = identifier
      }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let identifier = try container.decode(String.self, forKey: .identifier)
        if let messages = try container.decodeIfPresent([String : Message].self, forKey: .messages) {
            self.messages = Array(messages.values)
        } else {
            self.messages = []
        }
        self.title = title
        self.identifier = identifier
    }


class Message: Codable {
    
    let text: String
    let timeStamp: Date
    let displayName: String
    
    internal init(text: String, timeStamp: Date = Date(), displayName: String) {
           self.text = text
           self.timeStamp = timeStamp
           self.displayName = displayName
       }
}
}

extension ChatThread.Message : MessageType {
    var sender: SenderType {
        return Sender(senderId: "", displayName: "")
    }
    var messageId: String {
        return UUID().uuidString
    }
    var sentDate: Date {
        return timeStamp
    }
    var kind: MessageKind {
        return .text(text)
    }
}
struct Sender : SenderType {
    var senderId: String
    var displayName: String
}
