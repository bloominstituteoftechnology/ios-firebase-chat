//
//  ChatDetailViewController.swift
//  Firebase-Chat
//
//  Created by Yvette Zhukovsky on 1/8/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar


class ChatDetailViewController:  MessagesViewController, MessagesDataSource, MessagesDisplayDelegate, MessageInputBarDelegate, MessagesLayoutDelegate {
    
    var user: User?
    
    func currentSender() -> Sender {
        
        return Sender(id: (user?.id)!, displayName: (user?.name)!)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let msg = messages[indexPath.section]
        return msg
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        return messages.count
    }
    
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String)
    {
        guard
            let chatRoomId = chat?.id else { return }
        MessageController.createMessage(text: text,  chatId: chatRoomId) {
            DispatchQueue.main.async {
                inputBar.inputTextView.text = nil
            }
        }
    }
    
    
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int
    {
        return messages.count
    }
    
    
    var messages = [Message]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
    }
    let chatController = ChatController()
    
    let messageController = MessageController()
    var chat: Chat?
    {
        didSet
        {
            guard let chat = chat else { return }
            title = chat.name
            
        }
    }
    
    
    
    /*
     MARK: - Navigation
     
     In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     Get the new view controller using segue.destination.
     Pass the selected object to the new view controller.
     }
     */
    
}
