//
//  ChatMessagesViewController.swift
//  FirebaseChat
//
//  Created by Bobby Keffury on 12/6/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatMessagesViewController: MessagesViewController {
    
    // MARK: - Properties
    
    var chatRoom: ChatRoom?
    var chatRoomController: ChatRoomController?
    
    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        title = chatRoom?.title
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }

}

extension ChatMessagesViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        // Use dependency injection to provide a sender.
        // If there is no sender, create an alert to request it from the user.
        return Sender(senderId: "", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chatRoom!.messages[indexPath.item]
    }
        
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
}

extension ChatMessagesViewController: MessagesLayoutDelegate { }
extension ChatMessagesViewController: MessagesDisplayDelegate { }
