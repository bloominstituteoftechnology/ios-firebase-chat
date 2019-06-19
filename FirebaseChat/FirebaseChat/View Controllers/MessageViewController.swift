//
//  MessageViewController.swift
//  FirebaseChat
//
//  Created by Christopher Aronson on 6/18/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageViewController: MessagesViewController {

    var modelController: ModelController?
    var chatRoomName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }

}

extension MessageViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return Sender(displayName: "Topher", senderId: UUID().uuidString)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return modelController?.messages.count ?? 0
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    
        guard let message = modelController?.messages[indexPath.item] else {
            fatalError("No message for indexPath.item")
        }
        
        return message
    }
}

extension MessageViewController: MessagesDisplayDelegate {
    
}

extension MessageViewController: MessagesLayoutDelegate {
    
}

extension MessageViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let chatRoomName = chatRoomName,
        let sender = currentSender() as? Sender
        else { return }
        
        let newMessage = Message(sender: sender, sendDate: Date(), messageId: UUID().uuidString, text: text)
        
        modelController?.createMessage(in: chatRoomName, with: newMessage, completion: { error in
            
            if let error = error {
                NSLog("\(error)")
            }
            
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        })
    }
}
