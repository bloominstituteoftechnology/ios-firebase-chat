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
