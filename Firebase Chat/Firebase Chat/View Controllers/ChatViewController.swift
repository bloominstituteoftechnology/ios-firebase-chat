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
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
          layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        }
        
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        title = chatRoom.title
    }
}

// MARK: - ChatViewControllerDataSource

extension ChatViewController: MessagesDataSource {

    func currentSender() -> SenderType {
        guard let user = chatRoomController.currentUser else { fatalError("Current user not set") }
        return user
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatRoom.messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chatRoom.messages[indexPath.section]
    }
}

// MARK: - Messages Display and Layout Delegates

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        guard let user = chatRoomController.currentUser else { fatalError("Current user not set") }
        return message.sender.senderId == user.senderId ? .bubbleTail(.bottomRight, .curved) : .bubbleTail(.bottomLeft, .curved)
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        guard let user = chatRoomController.currentUser else { fatalError("Current user not set") }
        return message.sender.senderId == user.senderId ? #colorLiteral(red: 0.1733347178, green: 0.5859333873, blue: 0.973791182, alpha: 1) : #colorLiteral(red: 0.8981223702, green: 0.8978310227, blue: 0.9194632173, alpha: 1)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let user = chatRoomController.currentUser else { fatalError("Current user not set") }
        avatarView.isHidden = message.sender.senderId == user.senderId
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let user = chatRoomController.currentUser else { fatalError("Current user not set") }
        
        chatRoomController.createMessage(in: chatRoom, withText: text, from: user) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom(animated: true)
                self.messageInputBar.inputTextView.text = ""
            }
        }
    }
}
