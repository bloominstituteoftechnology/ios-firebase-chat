//
//  ChatDetailViewController.swift
//  Firebase Chat
//
//  Created by Michael on 2/25/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatDetailViewController: MessagesViewController {

    var chatRoomController: ChatRoomController? {
        didSet {
            
        }
    }
    
    var chatRoom: ChatRoom? {
        didSet {
            
        }
    }
    
    var currentUser: Sender? {
        didSet {
            
        }
    }
    
    private lazy var formatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        result.timeStyle = .medium
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let username = "Miguelito"
        let sender = Sender(senderId: UUID().uuidString, displayName: username)
        currentUser = sender
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatDetailViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        if let currentUser = chatRoomController?.currentUser {
            return currentUser
        } else {
            return Sender(senderId: UUID().uuidString, displayName: "Anonymous")
        }
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let message = chatRoom?.messages[indexPath.item] else {
            fatalError("No message found in Chat Room")
        }
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatRoom?.messages.count ?? 0
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let username = message.sender.displayName
        let attributes = [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .callout)]
        return NSAttributedString(string: username, attributes: attributes)
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        let attributes = [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .footnote)]
        return NSAttributedString(string: dateString, attributes: attributes)
    }
}

extension ChatDetailViewController: MessagesLayoutDelegate {
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
}

extension ChatDetailViewController: MessagesDisplayDelegate {
    
}

extension ChatDetailViewController: MessageInputBarDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard
            let chatRoom = self.chatRoom,
            let currentUser = currentUser,
            let chatRoomController = chatRoomController
            else { return }
        let newMessage = ChatRoom.Message(message: text, sender: currentUser)
        chatRoomController.createMessageCodable(in: chatRoom, with: newMessage.message, sender: currentUser)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}
