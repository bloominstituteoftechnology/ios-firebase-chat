//
//  ChatRoomDetailViewController.swift
//  FireBaseChat
//
//  Created by Enrique Gongora on 3/24/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatRoomDetailViewController: MessagesViewController {
    
    var room: ChatRoom?
    var chatRoomController: ChatRoomController?
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        chatRoomController?.fetchRooms {
            guard let room = self.room, let index = self.chatRoomController?.rooms.firstIndex(of: room) else { return }
            self.messages = self.chatRoomController?.rooms[index].messages ?? []
            self.messagesCollectionView.reloadData()
        }
    }
}

extension ChatRoomDetailViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let chatRoomController = chatRoomController, let room = room else { return }
        let message = Message(text: text, displayName: "User", messageId: UUID().uuidString, sentDate: Date())
        self.messages.append(message)
        chatRoomController.addMessageToRoom(room, message: message) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        }
    }
}

extension ChatRoomDetailViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
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
