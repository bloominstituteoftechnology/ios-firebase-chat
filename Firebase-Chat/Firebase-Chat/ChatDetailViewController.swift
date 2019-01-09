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
    func currentSender() -> Sender {
        guard let username = UserDefaults.standard.value(forKey: "username") as? String, let userId = UserDefaults.standard.value(forKey: "userId") as? String else { return Sender(id: "id", displayName: "name") }
        return Sender(id: userId, displayName: username)
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let msg = messages[indexPath.section]
        return msg
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
       
        return 1
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
       // messageInputBar.delegate = self as! MessageInputBarDelegate


    }

let messageController = MessageController()
    var chat: Chat?
    {
        didSet
        {
            guard let chat = chat else { return }
            title = chat.name
            messageController.fetchMessages(for: chat.id!) { (message) in
                
                DispatchQueue.main.async {
                    self.messages.append(message)
                    self.messagesCollectionView.reloadData()
                }
            }
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
