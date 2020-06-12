//
//  ModelController.swift
//  FirebaseChat
//
//  Created by Chad Parker on 2020-06-09.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation
import Firebase

protocol ModelControllerDelegate: AnyObject {
   func chatRoomsWereUpdated()
}

class ModelController {
   
   weak var delegate: ModelControllerDelegate!
   var ref: DatabaseReference!
   
   var chatRooms: [ChatRoom] = [] {
      didSet {
         delegate.chatRoomsWereUpdated()
      }
   }
   
   func createChatRoom(_ name: String) {
      print("create chat room here")
   }
   
   func fetchChatRooms() {
      
   }
   
   func createMessageInChatRoom(_ chatRoom: ChatRoom) {
      
   }
   
   func fetchMessagesInChatRoom(_ chatRoom: ChatRoom) {
      
   }
}
