//
//  ChatDetailViewController.swift
//  FirebaseChat
//
//  Created by Sal B Amer on 4/24/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

 
class ChatDetailViewController: MessagesViewController {
    
    //  Variables
    var room: ChatRoom?
    var messageController: MessageController?
    var messages = [Message]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messageController?.fetchChatRoom {
            guard let room = self.room, let index = self.messageController?.rooms.firstIndex(of: room) else { return }
            self.messages = self.messageController?.rooms[index].messages ?? []
            self.messagesCollectionView.reloadData()
        }
    }
}

extension ChatDetailViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let chatRoomController = messageController, let room = room else { return }
        let message = Message(text: text, displayName: "User", messageId: UUID().uuidString, sentDate: Date())
        print(message)
        self.messages.append(message)
        messageController?.addNewMessageinRoom(room, message: message) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        }
    }
}

extension ChatDetailViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
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
