//
//  MessageDetailViewController.swift
//  FirebaseChat
//
//  Created by Bradley Yin on 9/17/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import MessageKit
import InputBarAccessoryView

class MessageDetailViewController: MessagesViewController {
    
    // MARK: - Properties
    
    var chatRoomController: ChatRoomController?
    var chatRoom: ChatRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        chatRoom?.messages.sort(by: {$0.timestamp < $1.timestamp})
        
        messageInputBar.delegate = self
    }
    
    
}

extension MessageDetailViewController: MessagesDataSource {
    public func currentSender() -> SenderType {
        guard let user = chatRoomController?.currentUser else {
            fatalError("no user set")
            
        }
        return user
    }
    
    public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let message = chatRoom?.messages[indexPath.item] else { fatalError("no message")}
        return message
    }
    
    public func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    public func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatRoom?.messages.count ?? 0
    }
    
    
}

extension MessageDetailViewController: MessagesLayoutDelegate {
    
}

extension MessageDetailViewController: MessagesDisplayDelegate {
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        guard let user = chatRoomController?.currentUser else {
            fatalError("no user set")
        }
        if message.sender.senderId == user.senderId {
            return .bubbleTail(.bottomRight, .curved)
        } else {
            return .bubbleTail(.bottomLeft, .curved)
        }
        
    }
}

extension MessageDetailViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard let chatRoom = chatRoom else {
            fatalError("No thread set")
        }
        guard let user = chatRoomController?.currentUser else {
            fatalError("No user set")
        }
//        chatRoomController?.createMessage(in: chatRoom, withText: text, sender: user, completion: {
//            //update UI
//            DispatchQueue.main.async {
//                self.messagesCollectionView.reloadData()
//                self.messageInputBar.inputTextView.text = ""
//            }
//        })
    }
}
