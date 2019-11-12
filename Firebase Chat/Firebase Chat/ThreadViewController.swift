//
//  ThreadViewController.swift
//  Firebase Chat
//
//  Created by Isaac Lyons on 11/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MessageKit

class ThreadViewController: MessagesViewController {
    
    var messageThread: MessageThread?
    var messageThreadController: MessageThreadController?
    var sender: Sender = Sender(senderId: "0", displayName: "Test")

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
    }

}

extension ThreadViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        self.sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let message = messageThread?.messages[indexPath.section] else { fatalError() }
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageThread?.messages.count ?? 0
    }
}

extension ThreadViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}

extension ThreadViewController: MessageInputBarDelegate {
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        guard let thread = messageThread,
            let currentSender = currentSender() as? Sender else { return }
        
        messageThreadController?.createMessage(in: thread, withText: text, fromSender: currentSender, completion: {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        })
    }
}
