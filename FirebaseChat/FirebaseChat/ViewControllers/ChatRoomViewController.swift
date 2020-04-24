//
//  MessageViewController.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatRoomViewController: MessagesViewController {

    // MARK: - Properties
    
    var messageController: MessageController!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMessages(_:)), name: .messagesUpdated, object: nil)
    }
    
    @objc func updateMessages(_ notification: NSNotification) {
        messagesCollectionView.reloadData()
    }
}

// MARK: - Messages Data Source

extension ChatRoomViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return messageController.currentUser ?? User(id: "Foo", displayName: "Bar")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageController.messages[indexPath.row]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        self.messagesCollectionView = messagesCollectionView
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageController.messages.count
    }
}

// MARK: - Layout Delegate

extension ChatRoomViewController: MessagesLayoutDelegate {
    
}

// MARK: - Display Delegate

extension ChatRoomViewController: MessagesDisplayDelegate {
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        // Check if there is a message after this
        if indexPath.row < messageController.messages.count - 1 {
            var nextMessageIndexPath = indexPath
            nextMessageIndexPath.row += 1
            let nextMessage = messageController.messages[nextMessageIndexPath.row]
            
            // Check that the next message is from the same sender and within one minute
            if message.sender.senderId == nextMessage.sender.senderId &&
                message.sentDate.distance(to: nextMessage.sentDate) < 60 {
                
                // If so return regular buble
                return .bubble
            }
        }
        // Otherwise put the appropriate tail on the bubble
        let tailCorner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tailCorner, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let nameComponents = message.sender.displayName.components(separatedBy: " ")
        let initials = nameComponents.map { $0.prefix(1) }.joined()
        
        avatarView.initials = initials
    }
}

// MARK: - Input Bar Delegate

extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        messageController?.createMessage(with: text, from: messageController.currentUser ?? User(id: "Foo", displayName: "Bar"))
        inputBar.inputTextView.text = ""
    }
}

