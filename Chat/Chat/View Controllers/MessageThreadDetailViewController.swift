//
//  MessageThreadDetailViewController.swift
//  Message Board
//
//  Created by Nick Nguyen on 3/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageThreadDetailViewController: MessagesViewController , InputBarAccessoryViewDelegate {
    
    var messageThread: MessageThread?
    var chatroomController: ChatroomController?
    var chatroom: Chatroom?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let chatroom = chatroom else  { return }
        navigationItem.title = "In room: \(chatroom.name)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let messageThread = self.messageThread, let currentSender = currentSender() as? Sender else { return }
        self.chatroomController?.createMessage(in: messageThread, withText: text, sender: currentSender, completion: {
            self.messagesCollectionView.reloadData()
        })
        
        inputBar.inputTextView.text = ""
        
        
        
    }
 
    
}

extension MessageThreadDetailViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        if let currentSender = chatroomController?.currentUser {
            return currentSender
        }
        return Sender(senderId: UUID().uuidString, displayName: "Unknown user")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let message = self.messageThread?.messages[indexPath.item] else { fatalError("No message found in thread") }
        return message
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.messageThread?.messages.count ?? 0
    }
    
    
}

extension MessageThreadDetailViewController: MessagesLayoutDelegate {
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension MessageThreadDetailViewController: MessagesDisplayDelegate {
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .yellow : .green
    }
    
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let initials = String(message.sender.displayName.first ?? Character(""))
        let avatar = Avatar(image: nil, initials: initials)
        avatarView.set(avatar: avatar)
    }
    
    
    
    
    
    
    
    
}




















