//
//  ChatroomViewController.swift
//  FirebaseChat
//
//  Created by Jon Bash on 2019-12-17.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatroomViewController: MessagesViewController {
    var chatController: ChatController!
    var chatroom: ChatRoom?
    
    private func sendNewMessage(with text: String) {
        guard
            let sender = currentSender() as? Sender,
            !text.isEmpty
            else { return }
        
        chatController?.create(
            Message(
                sender: sender,
                text: text),
            in: chatroom! // nil just checked
        ) { error in
            if let error = error {
                NSLog("Error creating message: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        }
    }
    
    private func createNewChatRoom(named text: String) {
        guard
            let sender = chatController.currentUser,
            !text.isEmpty
            else { return }
        
        chatController?.create(ChatRoom(
            name: text,
            messages: [Message(sender: sender, text: text)])
        ) { error in
            if let error = error {
                NSLog("Error creating new chatroom: \(error)")
            }
        }
    }
}

// MARK: - MessagesDataSource

extension ChatroomViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return chatController.currentUser ??
            Sender(id: UUID().uuidString, displayName: "Unknown User")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let room = chatroom else {
            fatalError("No chatroom found for ChatroomViewController")
        }
        return room.messages[indexPath.item]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatroom?.messages.count ?? 0
    }
}

// MARK: - MessagesLayoutDelegate

extension ChatroomViewController: MessagesLayoutDelegate {
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

// MARK: - MessagesDisplayDelegate

extension ChatroomViewController: MessagesDisplayDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if chatroom == nil {
            createNewChatRoom(named: text)
        } else {
            sendNewMessage(with: text)
        }
        
        inputBar.inputTextView.text = ""
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue : .green
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = Avatar(image: nil, initials: message.sender.displayName)
        avatarView.set(avatar: avatar)
    }
}

extension ChatroomViewController: MessageInputBarDelegate {}
