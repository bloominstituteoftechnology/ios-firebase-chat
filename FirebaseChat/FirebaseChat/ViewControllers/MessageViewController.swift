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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignDelegates()
        // Do any additional setup after loading the view.
    }
    
    private func assignDelegates() {
        messageInputBar.delegate = self
//        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate = self
    }
    
}
