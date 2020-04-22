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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageController?.messagesDidSet = { [weak self] in
            self?.messagesCollectionView.reloadData()
        }
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = messageController
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension ChatRoomViewController: MessagesLayoutDelegate {
    
}

extension ChatRoomViewController: MessagesDisplayDelegate {
    
}

extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        messageController?.createMessage(with: text, from: User(id: "123", displayName: "Shawn"))
    }
}
