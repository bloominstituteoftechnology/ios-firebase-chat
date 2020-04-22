//
//  MessageViewController.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatRoomViewController: MessagesViewController {

    // MARK: - Properties
    
    var messageController: MessageController?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = messageController
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

// MARK: - Layout Delegate

extension ChatRoomViewController: MessagesLayoutDelegate {
    
}

// MARK: - Display Delegate

extension ChatRoomViewController: MessagesDisplayDelegate {
    
}

// MARK: - Input Bar Delegate

extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        messageController?.createMessage(with: text, from: User(id: "123", displayName: "Shawn"))
    }
}
