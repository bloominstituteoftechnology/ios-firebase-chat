//
//  MessageViewController.swift
//  firebaseChats
//
//  Created by Jesse Ruiz on 11/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MessageKit

class MessageViewController: MessagesViewController, MessageInputBarDelegate {
    
    var chatRoom: ChatRoom?
    var chatRoomController: ChatRoomsController?

    override func viewDidLoad() {
        super.viewDidLoad()
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension MessageViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        if let currentUser = chatRoomController?.currentUser {
            return currentUser
        } else {
            return Sender(senderId: UUID().uuidString, displayName: "Unknown User")
        }
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let message = chatRoom?.messages[indexPath.item] else {
            fatalError("No message found in thread")
        }
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatRoom?.messages.count ?? 0
    }
    
    
}

extension MessageViewController: MessagesLayoutDelegate {
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension MessageViewController: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue : .green
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let initials = String(message.sender.displayName.first ?? Character(""))
        let avatar = Avatar(image: nil, initials: initials)
        avatarView.set(avatar: avatar)
    }
    
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        guard let chatRoom = chatRoom,
            let currentSender = currentSender() as? Sender else { return }
        
        chatRoomController?.createMessage(in: chatRoom, withText: text, sender: currentSender, completion: {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        })
    }
}
