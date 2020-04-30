//
//  MessageThreadDetailTableViewController.swift
//  FireBaseChat
//
//  Created by Rachael Cedeno on 4/27/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseDatabase
import InputBarAccessoryView

class MessageThreadDetailTableViewController: MessagesViewController {
    
    // MARK: - Properties
    var messageThread: MessageThread? {
        didSet{
            self.observeData()
        }
    }
    var messageThreadController: MessageThreadController?
    var messages: [MessageThread.Message] = []
    var refHandler: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = messageThread?.title
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func observeData() {
        guard let messageThread = messageThread else { return }
        
        refHandler = self.messageThreadController?.ref.child("messages").child(messageThread.identifier).observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            do {
            let message = try MessageThread.Message(from: dictionary as! Decoder)
            self.insertMessage(message: message)
            } catch {
                print(error)
            }
        })
        
    }
    
    func insertMessage(message: MessageThread.Message) {
        messages.append(message)
    }
    
}

extension MessageThreadDetailTableViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: UUID().uuidString, displayName: "Denis")
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageThread?.messages.count ?? 0
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let message = messageThread!.messages[indexPath.section]
        return message
    }
}

extension MessageThreadDetailTableViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}

extension MessageThreadDetailTableViewController: InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        messageThreadController?.createMessage(in: messageThread!, withText: text, sender: "any", completion: {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
    }
}
