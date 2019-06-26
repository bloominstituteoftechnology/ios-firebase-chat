//
//  MessageViewController.swift
//  FirebaseMessages
//
//  Created by Jonathan Ferrer on 6/25/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageViewController: MessagesViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()

        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
    }

    
    var chatRoomController: ChatRoomController?
    var chatRoom: ChatRoom?
}

extension MessageViewController: MessagesDataSource {


    func currentSender() -> SenderType {
        // ADDED
        guard let currentUser = chatRoomController?.currentUser else {
            fatalError("No current user")
        }

        return currentUser
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }

    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatRoom?.messages.count ?? 0
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {

        guard let message = chatRoom?.messages[indexPath.item] else {
            fatalError("No message found for indexPath: \(indexPath)")
        }

        return message
    }
}


// MARK: - InputBarAccessoryViewDelegate

extension MessageViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        guard let chatRoom = chatRoom,
            let sender = currentSender() as? Sender else { return }

        chatRoomController?.createMessage(chatRoom: chatRoom, text: text, user: sender)

    }

}

extension MessageViewController: MessagesLayoutDelegate {

}

extension MessageViewController: MessagesDisplayDelegate {

}
