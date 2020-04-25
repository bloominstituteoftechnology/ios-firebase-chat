//
//  ChatViewController.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {

    // MARK: - Properties
    
    var chatRoomController: ChatRoomController?
    var chatRoom: ChatRoom?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
    }
}

// MARK: - ChatViewControllerDataSource

extension ChatViewController: MessagesDataSource {

    func currentSender() -> SenderType {
        guard let user = chatRoomController?.currentUser else { fatalError("Current user not set") }
        return user
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1 //chatRoom?.messages.count ?? 0
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatRoom?.messages.count ?? 0
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let message = chatRoom?.messages[indexPath.item] else { fatalError("Missing chat room") }
        return message
    }
}

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        guard let user = chatRoomController?.currentUser else { fatalError("Current user not set") }
        guard let message = chatRoom?.messages[indexPath.item] else { fatalError("Missing chat room") }
        
        return message.senderID == user.senderId ? .bubbleTail(.bottomRight, .curved) : .bubbleTail(.bottomLeft, .curved)
    }
}

// MARK: - ChatViewControllerDataSource

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("text: \(text)")
        guard let chatRoomController = chatRoomController else { fatalError("Missing chatRoomController") }
        guard let user = chatRoomController.currentUser else { fatalError("Current user not set") }
        guard let chat = chatRoom else { fatalError("Missing chat room") }
        
        chatRoomController.createMessage(in: chat, withText: text, from: user) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messageInputBar.inputTextView.text = ""
            }
        }
        // TODO: Create message by calling chatRoomController.create(message:)
    }
}
