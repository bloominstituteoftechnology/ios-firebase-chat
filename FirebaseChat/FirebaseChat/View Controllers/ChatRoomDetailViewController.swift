//
//  ChatRoomDetailViewController.swift
//  FirebaseChat
//
//  Created by Lambda_School_Loaner_204 on 12/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatRoomDetailViewController: MessagesViewController, InputBarAccessoryViewDelegate {

    var chatRoom: ChatRoom?
    var chatRoomController: ChatRoomController?
    let messageController = MessageController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let chatRoom = chatRoom else { return }
        messageController.fetchMessages(in: chatRoom) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        }
    }
}

extension ChatRoomDetailViewController: MessagesDataSource {
    func currentSender() -> SenderType {
//        if let currentUser = self.chatRoomController?.currentUser {
//            return currentUser
//        } else {
        return Sender(senderId: UUID().uuidString, displayName: "Unknown User")
//        }
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let message = self.chatRoom?.messages[indexPath.item] else {
            fatalError("No message found in thread")
        }
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.chatRoom?.messages.count ?? 0
    }
}

extension ChatRoomDetailViewController: MessagesLayoutDelegate {
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension ChatRoomDetailViewController: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue : .green
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let initials = String(message.sender.displayName.first ?? Character(""))
        let avatar = Avatar(image: nil, initials: initials)
        avatarView.set(avatar: avatar)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let chatRoom = self.chatRoom,
            let currentSender = currentSender() as? Sender else { return }
        
        self.messageController.createMessage(in: chatRoom, withText: text, sender: currentSender, completion: {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        })
        
        inputBar.inputTextView.text = ""
    }
}
