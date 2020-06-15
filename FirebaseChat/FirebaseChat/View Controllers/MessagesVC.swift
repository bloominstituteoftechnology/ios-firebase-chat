//
//  MessagesVC.swift
//  FirebaseChat
//
//  Created by Chad Parker on 2020-06-09.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessagesVC: MessagesViewController {
   
   var chatRoom: ChatRoom!
   var modelController: ModelController!
   
   private var messages: [Message] = [] {
      didSet {
         messagesCollectionView.reloadData()
      }
   }
   
   private let sender = Sender(senderId: UUID().uuidString, displayName: "Chad")
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      title = chatRoom.name
      messagesCollectionView.messagesDataSource = self
      messagesCollectionView.messagesLayoutDelegate = self
      messagesCollectionView.messagesDisplayDelegate = self
      messageInputBar.delegate = self
      loadMessages()
   }
   
   private func loadMessages() {
      modelController.fetchMessagesInChatRoom(chatRoom) { messages in
         self.messages = messages
      }
   }
}

extension MessagesVC: MessagesDataSource {
   
   func currentSender() -> SenderType {
      return sender
   }
   
   func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
      // MessageKit requires us to use 1 section per message
      // https://github.com/MessageKit/MessageKit/blob/master/Documentation/QuickStart.md
      return messages[indexPath.section]
   }
   
   func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
      return messages.count
   }
}

extension MessagesVC: MessagesLayoutDelegate {
   
}

extension MessagesVC: MessagesDisplayDelegate {
   
}

extension MessagesVC: InputBarAccessoryViewDelegate {
   
   func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
      modelController.createMessageInChatRoom(message: Message(text: text), chatRoom: chatRoom)
      inputBar.inputTextView.text = nil
      loadMessages()
   }
}
