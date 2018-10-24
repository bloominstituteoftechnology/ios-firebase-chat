//
//  MessageViewController.swift
//  iOS Firebase Chat
//
//  Created by Dillon McElhinney on 10/23/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar

class MessageViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, MessageInputBarDelegate {

    // MARK: - Properties
    var firebaseController: FirebaseContoller!
    var chatroom: Chatroom!
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return formatter
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        firebaseController.loadMessages(for: chatroom) { (_) in
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firebaseController.closeMessages()
    }

    // MARK: - Messages Data Source
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return firebaseController.messages.count
    }
    
    func currentSender() -> Sender {
        return firebaseController.currentSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return firebaseController.messages[indexPath.row]
    }
    
    // MARK: - Messages Layout
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)]
        
        return NSAttributedString(string: name, attributes: attributes)
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let date = message.sentDate
        let dateString = dateFormatter.string(from: date)
        let attributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)]
        
        return NSAttributedString(string: dateString, attributes: attributes)
    }
    
    // MARK: - Messages Display Delegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if isFromCurrentSender(message: message) {
            return .lightBlue
        } else {
            return .lighterGray
        }
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if isFromCurrentSender(message: message) {
            return .white
        } else {
            return .black
        }
        
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return MessageStyle.bubbleTail(corner, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let name = message.sender.displayName
        let names = name.components(separatedBy: .whitespaces)
        let firstInitial = String(names.first?.first ?? "?")
        var lastInitial = ""
        if names.count > 1 { lastInitial = String(names.last?.first ?? Character("")) }
        
        avatarView.initials = firstInitial + lastInitial
    }
    
    // MARK: - Messages Input Bar
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        firebaseController.addMessage(to: chatroom, with: text, sender: currentSender())
        inputBar.inputTextView.text = ""
    }
}
