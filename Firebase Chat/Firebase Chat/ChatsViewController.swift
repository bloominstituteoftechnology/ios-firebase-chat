//
//  ChatsViewController.swift
//  Firebase Chat
//
//  Created by Nelson Gonzalez on 3/5/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar
import Firebase

class ChatsViewController: MessagesViewController {
    
    var chatsController: ChatsController?
    var chats: Chats?
    var messages: [Message] = [] {
        didSet {
            self.messagesCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        loadPosts()
    }
    
    func loadPosts(){
        guard isViewLoaded else {return}
        Database.database().reference().child("my-messages").observe(.childAdded) { (snapshot) in
            //   print(snapshot.value)
            if let dict = snapshot.value as? [String: Any] {
                let captionText = dict["text"] as! String
                let uid = dict["uid"] as! String
               // let post = Post(captionText: captionText, photoUrlString: photoUrlString)
                let messages = Message(chats: nil, text: captionText, displayName: uid, senderID: uid, messageId: snapshot.key)
                self.messages.append(messages)
                self.messagesCollectionView.reloadData()
             //   print(self.messages)
            }
        }
    }
    

}

extension ChatsViewController: MessagesDataSource {
    //Who is the current user or sender
    //Used to know where to put messages (left or right)
    func currentSender() -> Sender {
        if let currentUser = chatsController?.currentUser {
            return currentUser
        } else {
            return Sender(id: "any_unique_id", displayName: "Steven")
        }
        // return Sender(id: "any_unique_id", displayName: "Steven")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
       // return chatsController?.messages.count ?? 0
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
       
       // guard let message = chatsController?.messages[indexPath.item] else {
         let message = messages[indexPath.item] 
        return message
    }
    
    
}

extension ChatsViewController: MessagesLayoutDelegate {
    
}

extension ChatsViewController: MessagesDisplayDelegate {
    
}

extension ChatsViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        for component in inputBar.inputTextView.components {
            
            if let str = component as? String {
                
                _ = chatsController?.uploadMessagesToServer(chat: chats ,id: (chats?.id)!, text: str, onSuccess: {
                    print("Message submitted")
                })
                
//                let message = MockMessage(text: str, sender: currentSender(), messageId: UUID().uuidString, date: Date())
//                insertMessage(message)
            }
            
        }
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
}
