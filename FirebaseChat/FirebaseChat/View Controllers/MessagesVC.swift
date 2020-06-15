//
//  MessagesVC.swift
//  FirebaseChat
//
//  Created by Chad Parker on 2020-06-09.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit

class MessagesVC: UIViewController {
   
   var chatRoom: ChatRoom!
   var modelController: ModelController!
   
   private var messages: [Message] = [] {
      didSet {
         print(messages)
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      title = chatRoom.name
      loadMessages()
   }
   
   private func loadMessages() {
      modelController.fetchMessagesInChatRoom(chatRoom) { messages in
         self.messages = messages
      }
   }
}
