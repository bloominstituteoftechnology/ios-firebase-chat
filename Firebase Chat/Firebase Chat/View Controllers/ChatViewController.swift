//
//  ChatViewController.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController {

    // MARK: - Properties
    
    var chatRoomController: ChatRoomController?
    var chatRoom: ChatRoom?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

// MARK: - ChatViewControllerDataSource

extension ChatViewController: MessagesDataSource {

    func currentSender() -> SenderType {
        guard let user = chatRoomController?.currentUser else { fatalError("Current user not set") }
        return user
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1 //chatRoom?.messages.count ?? 0
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatRoom?.messages.count ?? 0
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let message = chatRoom?.messages[indexPath.item] else { fatalError("Missing chat room") }
        return message
    }
}

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}
