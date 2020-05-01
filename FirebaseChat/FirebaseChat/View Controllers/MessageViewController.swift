//
//  MessageViewController.swift
//  FirebaseChat
//
//  Created by Jessie Ann Griffin on 4/24/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageViewController: MessagesViewController {
    
    // MARK: - Properties
    
    var chatRoom: ChatRoom?
    var chatRoomController: ChatRoomController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = chatRoom?.title
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "AddMessage" {
//            guard let destinationVC = segue.destination as? MessageDetailViewController else { return }
//            
//            destinationVC.chatRoomController = chatRoomController
//            destinationVC.chatRoom = chatRoom
//        }
//    }
}

extension MessageViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return Sender(senderId: UUID().uuidString, displayName: "Jessie")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatRoom?.messages.count ?? 0
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        let message = chatRoom!.messages[indexPath.section]
        
        return message
    }
}

extension MessageViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
//    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        
//    }
}

extension MessageViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
                
        chatRoomController?.createMessage(in: self.chatRoom!, withText: text, sender: currentSender().senderId, completion: {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        })
    }
}

