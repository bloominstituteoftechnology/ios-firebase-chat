//
//  ChatViewController.swift
//  firebase-chat
//
//  Created by Joe on 4/26/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController {
    
    var messageThread: MessageThread?
    var networkController: NetworkController?

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        title = messageThread?.title
    }
}

 extension ChatViewController: MessagesDataSource {
            func currentSender() -> SenderType {
                return Sender(senderId: UUID().uuidString, displayName: "Aaron")
            }

            func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
                return messageThread?.messages.count ?? 0
            }

            func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
                let message = messageThread!.messages[indexPath.section]
                return message
            }
        }
        
    extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}


