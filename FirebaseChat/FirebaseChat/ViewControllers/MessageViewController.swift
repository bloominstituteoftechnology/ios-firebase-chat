//
//  MessageViewController.swift
//  FirebaseChat
//
//  Created by Shawn James on 5/19/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageViewController: MessagesViewController, InputBarAccessoryViewDelegate {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
    }
    
    // MARK: - Methods
    private func assignDelegates() {
        messageInputBar.delegate = self
//        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate = self
    }
    
}
