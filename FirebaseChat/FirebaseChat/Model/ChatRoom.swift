//
//  ChatRoom.swift
//  FirebaseChat
//
//  Created by Chad Parker on 2020-06-09.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation

struct ChatRoom {
   
   let id: String
   let name: String
   var messages: [Message]
   
   init(id: String = UUID().uuidString, name: String, messages: [Message] = []) {
      self.id = id
      self.name = name
      self.messages = messages
   }
   
   init?(id: String, dict: [String: Any]) {
      guard let name = dict["name"] as? String else { return nil }

      self.id = id
      self.name = name
      self.messages = [] // still need to parse messages
   }
}
