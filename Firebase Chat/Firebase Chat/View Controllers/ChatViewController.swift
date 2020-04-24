//
//  ChatViewController.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController {

    // MARK: - Properties
    
    let chatRoom: ChatRoom!
    var messages: [MessageType] = []
    
    // MARK: - View Lifecycle

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

// MARK: - ChatViewControllerDataSource

extension ChatViewController: MessagesDataSource {

    func currentSender() -> SenderType {
        return Sender(senderId: UUID().uuidString, displayName: "Steven")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatRoom.messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chatRoom.messages[indexPath.section] as! MessageType
    }
}

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}
