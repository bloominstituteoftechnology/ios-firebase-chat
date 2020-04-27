//
//  MessageDetailViewController.swift
//  FirebaseChat
//
//  Created by Joshua Rutkowski on 4/26/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

// Resource: - https://github.com/MessageKit/MessageKit/blob/master/Documentation/QuickStart.md
class MessageDetailViewController: MessagesViewController {
    
    // MARK: - Variables
    var room: ChatRoom?
    var chatController: ChatController?
    var messages = [Message]()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        chatController?.fetchRooms {
            guard let room = self.room, let index = self.chatController?.rooms.firstIndex(of: room) else { return }
            self.messages = self.chatController?.rooms[index].messages ?? []
            self.messagesCollectionView.reloadData()
        }
    }
}

extension MessageDetailViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let chatRoomController = chatController, let room = room else { return }
        let message = Message(text: text, displayName: "User", messageId: UUID().uuidString, sentDate: Date())
        print(message)
        self.messages.append(message)
        chatRoomController.addMessageToRoom(room, message: message) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        }
    }
}

extension MessageDetailViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return Sender(senderId: UUID().uuidString, displayName: "User")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let message = messages[indexPath.item]
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
