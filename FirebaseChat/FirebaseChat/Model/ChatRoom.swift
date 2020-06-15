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
   
   init(id: String = UUID().uuidString, name: String) {
      self.id = id
      self.name = name
   }
   
   init?(id: String, dict: [String: Any]) {
      guard let name = dict["name"] as? String else { return nil }

      self.id = id
      self.name = name
   }
}
