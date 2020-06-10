//
//  ChatRoomMessagesViewController.swift
//  FirebaseChat
//
//  Created by Thomas Dye on 06/5/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import Foundation
import MessageKit


class ChatRoomMessagesViewController: MessagesViewController {
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
}


extension ChatRoomMessagesViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return messages[0].sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[0]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 0
    }
    
    
}

extension ChatRoomMessagesViewController: MessagesLayoutDelegate {
    
}

extension ChatRoomMessagesViewController: MessagesDisplayDelegate {
    
}
