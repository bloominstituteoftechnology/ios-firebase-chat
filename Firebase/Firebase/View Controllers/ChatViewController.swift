//
//  ChatViewController.swift
//  Firebase
//
//  Created by Alex Thompson on 2/16/20.
//  Copyright © 2020 Lambda_School_Loaner_213. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseDatabase

class ChatViewController: MessagesViewController {
    var chatController: ModelController?
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
        
        self.loadFirstMessages()

    }
    
    private func loadFirstMessages() {
        guard let chat = self.chat else { return }
    }
    
    private func observeData() {
        guard let chat = chat else { return }
        
        self.refHandler = self.chatController?.ref.child("messages").child(chat.identifier).observe(.childAdded) { (snapshot) in
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

extension ChatViewController: MessagesDataSource {
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> SenderType {
        return Sender(id: "", displayName: "")
    }
}

extension ChatViewController: MessagesLayoutDelegate {}

extension ChatViewController: MessagesDisplayDelegate {}

extension ChatViewController: MessageInputBarDelegate {
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        if let chat = self.chat {
            self.createMessage(chat: chat, text: text)
        } else {
            self.createChat(text: text)
        }
    }
    
    private func createMessage(chat: Chat, text: String) {
        self.chatController?.createMessage(in: chat, withText: text) { message in
            DispatchQueue.main.async {
                self.messageInputBar.inputTextView.text = nil
            }
        }
    }
    
    private func createChat(text: String) {
        self.chatController?.createChat { chat in
            if let chat = chat {
                self.chat = chat
                
                self.createMessage(chat: chat, text: text)
            }
        }
    }
}
