//
//  ChatDetailViewController.swift
//  FirebaseChat
//
//  Created by Simon Elhoej Steinmejer on 18/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit
import MessageKit

class ChatMessageViewController: MessagesViewController, MessagesDataSource, MessagesDisplayDelegate, MessageInputBarDelegate, MessagesLayoutDelegate
{
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 100
    }
    
    let messageController = MessageController()
    var messages = [Message]()
    
    var chatRoom: ChatRoom?
    {
        didSet
        {
            guard let chatRoom = chatRoom else { return }
            title = chatRoom.name
            messageController.fetchMessages(for: chatRoom.id!) { (message) in
                
                DispatchQueue.main.async {
                    self.messages.append(message)
                    self.messagesCollectionView.reloadData()
                }
            }
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        iMessage()
    }
    
    func currentSender() -> Sender
    {
        guard let username = UserDefaults.standard.value(forKey: "username") as? String, let userId = UserDefaults.standard.value(forKey: "userId") as? String else { return Sender(id: "id", displayName: "name") }
        return Sender(id: userId, displayName: username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType
    {
        let message = messages[indexPath.section]
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int
    {
        return 1
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int
    {
        return messages.count
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
    {
        print(message.sender.displayName)
        let name = message.sender.displayName
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        return NSAttributedString(string: name, attributes: attributes)
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
    {
        print(message.sentDate)
        let dateString = formatter.string(from: message.sentDate)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]
        return NSAttributedString(string: dateString, attributes: attributes)
    }
    
    private lazy var formatter: DateFormatter =
    {
        let result = DateFormatter()
        result.dateStyle = .medium
        result.timeStyle = .medium
        
        return result
    }()
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String)
    {
        guard let username = UserDefaults.standard.value(forKey: "username") as? String, let chatRoomId = chatRoom?.id else { return }
        messageController.createMessage(text: text, sender: username, chatRoomId: chatRoomId) {
            DispatchQueue.main.async {
                inputBar.inputTextView.text = nil
            }
        }
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat
    {
        return 16
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat
    {
        return 16
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor
    {
        guard let username = UserDefaults.standard.value(forKey: "username") as? String else { return UIColor.green}
        if message.sender.displayName == username
        {
            return UIColor.darkGray
        }
        else
        {
            return UIColor.green
        }
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)
    {
        let message = messages[indexPath.section]
        let initial = String((message.senderName?.first)!)
        avatarView.initials = "\(initial)"
    }
    
    
    
    func iMessage() {
        defaultStyle()
        messageInputBar.isTranslucent = false
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: true)
        messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: true)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: true)
        messageInputBar.sendButton.image = #imageLiteral(resourceName: "icons8-up_arrow")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        messageInputBar.sendButton.backgroundColor = .clear
        messageInputBar.textViewPadding.right = -38
    }
    
    func defaultStyle() {
        let newMessageInputBar = MessageInputBar()
        newMessageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        newMessageInputBar.delegate = self
        messageInputBar = newMessageInputBar
        reloadInputViews()
    }
}





















