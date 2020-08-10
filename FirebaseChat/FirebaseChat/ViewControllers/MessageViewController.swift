//
//  MessageViewController.swift
//  FirebaseChat
//
//  Created by Elizabeth Thomas on 8/10/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit
import Firebase
import MessageKit

class MessageViewController: MessagesViewController {
    
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MessageViewController: MessagesDataSource {
    public func currentSender() -> SenderType {

    }
    
    public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {

    }
    
    public func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 0
    }
    
    
}

extension MessageViewController: MessagesLayoutDelegate {
    
}

extension MessageViewController: MessagesDisplayDelegate {
    
}
