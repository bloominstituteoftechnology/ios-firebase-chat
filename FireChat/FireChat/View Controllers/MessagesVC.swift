//
//  MessagesVC.swift
//  FireChat
//
//  Created by Ezra Black on 4/25/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//
import UIKit
import MessageKit
import InputBarAccessoryView

class MessagesVC: MessagesViewController {

    //MARK: - IBOutlets
    
    
    //MARK: - Properties
    
    let chatController = ChatController()
    let sender = Sender(id: "Santana", displayName: "Jeffrey Santana")
    var group: Group!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        listenForMessageUpdates()
    }
    
    //MARK: - IBActions
    
    
    //MARK: - Helpers
    
    func setupView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        title = group.title
    }
    
    func listenForMessageUpdates() {
        chatController.fetchMessages(for: group) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        }
    }
    
}

extension MessagesVC: MessagesDataSource {
    func currentSender() -> SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chatController.messages[indexPath.item]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatController.messages.count
    }
}

extension MessagesVC: MessagesLayoutDelegate {
    
}

extension MessagesVC: MessagesDisplayDelegate {
    
}

extension MessagesVC: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard text.count > 0 else { return }
        
        chatController.createMessage(for: group, from: sender, with: text) {
            DispatchQueue.main.async {
                inputBar.inputTextView.text = ""
            }
        }
    }
}
