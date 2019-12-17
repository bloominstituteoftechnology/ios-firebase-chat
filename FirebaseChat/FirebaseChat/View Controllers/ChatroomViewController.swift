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
    // MARK: - Properties
    
    var chatController: ChatController!
    var chatroom: ChatRoom? {
        didSet {
            DispatchQueue.main.async { self.title = self.chatroom?.name }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    // MARK: - Helper Methods
    
    private func sendNewMessage(
        with text: String,
        didCompleteWithErrorMessage: @escaping (String?) -> Void)
    {
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
                didCompleteWithErrorMessage("Error creating message: \(error)")
            } else { didCompleteWithErrorMessage(nil) }
        }
    }
    
    private func createNewChatRoom(
        named text: String,
        didCompleteWithErrorMessage: @escaping (String?) -> Void)
    {
        guard !text.isEmpty else { return }
        
        chatroom = ChatRoom(name: text)
        chatController?.create(ChatRoom(name: text)) { error in
            if let error = error {
                self.chatroom = nil
                didCompleteWithErrorMessage("Error creating new chatroom: \(error)")
            } else { didCompleteWithErrorMessage(nil) }
        }
    }
}

// MARK: - MessagesDataSource

extension ChatroomViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return chatController.currentUser ??
            Sender(id: UUID().uuidString, displayName: "Unknown User")
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> MessageType {
        guard let room = chatroom else {
            fatalError("No chatroom found for ChatroomViewController")
        }
        return room.messages[indexPath.item]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(
        inSection section: Int,
        in messagesCollectionView: MessagesCollectionView
    ) -> Int {
        return chatroom?.messages.count ?? 0
    }
}

// MARK: - MessagesLayoutDelegate

extension ChatroomViewController: MessagesLayoutDelegate {
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> CGFloat {
        return 16
    }
}

// MARK: - MessagesDisplayDelegate

extension ChatroomViewController: MessagesDisplayDelegate {
    func inputBar(
        _ inputBar: InputBarAccessoryView,
        didPressSendButtonWith text: String)
    {
        // handler for text depending on conditions
        func creationDidComplete(withErrorMessage errorMessage: String?) {
            if let errorMessage = errorMessage {
                NSLog(errorMessage)
                DispatchQueue.main.async {
                    inputBar.inputTextView.text = text
                }
                return
            }
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        }
        
        if chatroom == nil {
            createNewChatRoom(
                named: text,
                didCompleteWithErrorMessage: creationDidComplete(withErrorMessage:))
        } else {
            sendNewMessage(
                with: text,
                didCompleteWithErrorMessage: creationDidComplete(withErrorMessage:))
        }
        
        inputBar.inputTextView.text = ""
    }
    
    func textColor(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue : .green
    }
    
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView)
    {
        let avatar = Avatar(image: nil, initials: message.sender.displayName)
        avatarView.set(avatar: avatar)
    }
}

// MARK: - MessageInputBarDelegate

extension ChatroomViewController: MessageInputBarDelegate {}
