//
//  MessageViewController.swift
//  Chat
//
//  Created by Chris Dobek on 5/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageViewController: MessagesViewController, InputBarAccessoryViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.delegate = self
//        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate = self

        
    }

}
