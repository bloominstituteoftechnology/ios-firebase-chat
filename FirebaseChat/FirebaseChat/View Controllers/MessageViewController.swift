//
//  MessageViewController.swift
//  FirebaseChat
//
//  Created by John Kouris on 12/7/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageViewController: MessagesViewController {
    
    var chatController: ChatRoomController?
    var chatRoom: ChatRoom?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = chatRoom?.title
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }

}

extension MessageViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: "", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chatRoom!.messages[indexPath.item]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
}

extension MessageViewController: MessagesLayoutDelegate {
    
}

extension MessageViewController: MessagesDisplayDelegate {
    
}

extension MessageViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        chatController?.createMessage(in: chatRoom!)
    }
}
