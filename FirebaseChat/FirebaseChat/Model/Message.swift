//
//  Message.swift
//  FirebaseChat
//
//  Created by Chad Parker on 2020-06-09.
//  Copyright © 2020 Chad Parker. All rights reserved.
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
   
   init?(id: String, dict: [String: Any]) {
      guard let text = dict["text"] as? String else { return nil }
      
      self.id = id
      self.text = text
      // need to parse date
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
