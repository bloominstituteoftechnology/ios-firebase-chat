//
//  MessageViewController.swift
//  firebaseSDK
//
//  Created by Karen Rodriguez on 4/21/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit
import MessageKit

let sender = Sender(senderId: "AnyID", displayName: "EL ROVERTOOO")
let messages: [MessageType] = []

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
        return Sender(senderId: "anyID", displayName: "EL ROVERTOOO")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
