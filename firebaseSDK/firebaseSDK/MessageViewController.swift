//
//  MessageViewController.swift
//  firebaseSDK
//
//  Created by Karen Rodriguez on 4/21/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit
import MessageKit

let sender = User(senderId: "AnyID", displayName: "EL ROVERTOOO")
let message = UserPost(sender: sender, messageId: "123", sentDate: Date(), kind: MessageKind.text("ESKETIIIT"))
let messages: [MessageType] = [message]

class MessageViewController: MessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        // Do any additional setup after loading the view.
    }

}

extension MessageViewController: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    func currentSender() -> SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
