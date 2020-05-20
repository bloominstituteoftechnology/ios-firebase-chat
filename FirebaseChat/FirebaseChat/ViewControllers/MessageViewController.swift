//
//  MessageViewController.swift
//  FirebaseChat
//
//  Created by Shawn James on 5/19/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase

class MessageViewController: MessagesViewController, InputBarAccessoryViewDelegate {
    
    // MARK: - Properties
    let databaseReference = Database.database().reference()
    var conversation: String?
    var conversationReference: DatabaseReference? {
        didSet { title = conversation }
    }
    var messages = [MessageType]()
    private lazy var formatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        result.timeStyle = .medium
        return result
    }()
    let dateFormatter = ISO8601DateFormatter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNewMessages()
        assignDelegates()
    }
    
    // MARK: - Methods
    private func fetchNewMessages() {
        guard let conversationReference = conversationReference else { return }
        conversationReference.child("messages").observe(.childAdded) { (dataSnapshot) in
            var text: String!
            var displayName: String!
            var senderId: String!
            var messageId: String!
            var sentDate: String!
            for child in dataSnapshot.children {
                let snap = child as! DataSnapshot
                if snap.key == "text" { text = snap.value as? String }
                if snap.key == "displayName" { displayName = snap.value as? String }
                if snap.key == "senderId" { senderId = snap.value as? String }
                if snap.key == "messageId" { messageId = snap.value as? String }
                if snap.key == "sentDate" { sentDate = snap.value as? String }
            }
            let message = Message(text: text,
                                  displayName: displayName,
                                  senderId: senderId,
                                  messageId: messageId,
                                  sentDate: self.dateFormatter.date(from: sentDate)!)
            self.messages.append(message)
            self.messagesCollectionView.reloadData()
        }
    }
    
    private func assignDelegates() {
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
}

extension MessageViewController: MessagesDataSource {
    
    // ---- Required Delegate Methods ----
    
    // Who is the current user (Sender)?
    // Used to know where to put messages (left or right)
    func currentSender() -> SenderType {
        Sender(senderId: UserDefaults.standard.string(forKey: "senderId")!,
               displayName: UserDefaults.standard.string(forKey: "displayName")!)
    }

func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int { 1 }

func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
    return messages.count
}

func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
    let message = messages[indexPath.item]
    return message
}

// -----------------------------------

func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    let name = message.sender.displayName
    let attrs = [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .caption1)]
    return NSAttributedString(string: name, attributes: attrs)
}

func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
    let dateString = formatter.string(from: message.sentDate)
    let attrs = [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .caption2)]
    return NSAttributedString(string: dateString, attributes: attrs)
}
}

extension MessageViewController: MessagesLayoutDelegate {
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat { 16 }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat { 16 }
    
}

extension MessageViewController: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? .blue : .green
    }
    
    // Adds tails onto the messages
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    // Sets the senders first initial in the avatar circle view
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let initials = String(message.sender.displayName.first ?? Character(""))
        let avatar = Avatar(image: nil, initials: initials)
        avatarView.set(avatar: avatar)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard conversationReference != nil, !text.isEmpty else { return }
        // use text to create message for conversation
        let newMessage: [String:Any] = ["text" : text,
                                        "messageId" : UUID().uuidString,
                                        "senderId" : UserDefaults.standard.string(forKey: "senderId")!,
                                        "displayName" : UserDefaults.standard.string(forKey: "displayName")!,
                                        "sentDate" : dateFormatter.string(from: Date())]
        conversationReference!.child("messages").childByAutoId().setValue(newMessage)
    }
}
