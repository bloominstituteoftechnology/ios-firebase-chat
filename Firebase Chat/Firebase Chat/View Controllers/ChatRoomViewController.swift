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
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    private func observeData() {
        guard let chat = chat else { return }
        
        self.refHandler = self.chatController.ref.child("messages").child(chat.identifier).observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }

            let message = Message(dictionary: dictionary)
            self.insertMessage(message: message)
        }
    }
    
    private func insertMessage(message: Message) {
        self.messages.append(message)
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom()
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

extension ChatRoomViewController: MessagesLayoutDelegate {}

extension ChatRoomViewController: MessagesDisplayDelegate {}

extension ChatRoomViewController: MessageInputBarDelegate {
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        if let chat = self.chat {
            self.createMessage(chat: chat, text: text)
        } else {
            self.createChat(text: text)
        }
    }
    
    private func createMessage(chat: Chat, text: String) {
        // create a new message
        self.chatController.createMessage(in: chat, withText: text) { message in
            //
            DispatchQueue.main.async {
                self.messageInputBar.inputTextView.text = nil
            }
        }
    }
    
    private func createChat(text: String) {
        // create a new chat room
        self.chatController.createChat { chat in
            if let chat = chat {
                // start observing the chat
                self.chat = chat
                
                // create a new message
                self.createMessage(chat: chat, text: text)
            }
        }
    }
}
