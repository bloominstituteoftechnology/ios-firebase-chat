//
//  ChatRoomViewController.swift
//  Firebase Chat
//
//  Created by Vici Shaweddy on 12/4/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseDatabase

class ChatRoomViewController: MessagesViewController {
    let chatController = ChatModelController()
    var chat: Chat? {
        didSet {
            self.observeData()
        }
    }
    var refHandler: DatabaseHandle?
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    private func observeData() {
        guard let chat = chat else { return }
        
        self.refHandler = self.chatController.ref.child("messages").child(chat.identifier).observe(.value) { (snapshot) in
            var messages = [Message]()
            for child in snapshot.children {
                let message = Message(snapshot: child as! DataSnapshot)
                messages.append(message)
            }
            self.messages = messages
        }
    }
}

extension ChatRoomViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: "any_unique_id", displayName: "Steven")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}

extension ChatRoomViewController: MessageInputBarDelegate {
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // create a new chat room
        
        chatController.createChat { chat in
            if let chat = chat {
                // start observing the chat
                self.chat = chat
                
                // create a new message
                self.chatController.createMessage(in: chat, withText: text) { message in
                    //
                }
            }
        }

    }
}
