//
//  MessageViewController.swift
//  FirebaseChat
//
//  Created by Gi Pyo Kim on 11/12/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit
import MessageKit

class MessageViewController: MessagesViewController {
    
    var chatRoomController: ChatRoomController?
    var chatRoom: ChatRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let chatRoomController = chatRoomController, let chatRoom = chatRoom else { return }
        
        chatRoomController.fetchMessage(chatRoom: chatRoom, completion: {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        })
        
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

extension MessageViewController: MessagesLayoutDelegate, MessagesDisplayDelegate, MessageInputBarDelegate {
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue: .green
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let initals = String(message.sender.displayName.first ?? Character(""))
        let avatar = Avatar(image: nil, initials: initals)
        avatarView.set(avatar: avatar)
    }
    
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        guard let chatRoom = chatRoom, let currentSender = currentSender() as? Sender else {return}
        
        chatRoomController?.createMessage(chatRoom: chatRoom, text: text, sender: currentSender, completion: {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        })
    }
}
