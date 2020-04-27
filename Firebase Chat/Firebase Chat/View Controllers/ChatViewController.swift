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
    
    var chatRoomController: ChatRoomController!
    var chatRoom: ChatRoom!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        chatRoomController.fetchMessages(in: chatRoom) {
            self.messagesCollectionView.reloadData()
        }
    }
}

// MARK: - ChatViewControllerDataSource

extension ChatViewController: MessagesDataSource {

    func currentSender() -> SenderType {
        guard let user = chatRoomController?.currentUser else { fatalError("Current user not set") }
        return user
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatRoom?.messages.count ?? 0
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chatRoom.messages[indexPath.item]
    }
}

// MARK: - Messages Display and Layout Delegates

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        guard let user = chatRoomController.currentUser else { fatalError("Current user not set") }
        let message = chatRoom.messages[indexPath.item]
        
        return message.senderID == user.senderId ? .bubbleTail(.bottomRight, .curved) : .bubbleTail(.bottomLeft, .curved)
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("text: \(text)")
        guard let user = chatRoomController.currentUser else { fatalError("Current user not set") }
        
        chatRoomController.createMessage(in: chatRoom, withText: text, from: user) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messageInputBar.inputTextView.text = ""
            }
        }
    }
}
