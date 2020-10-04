//
//  MessageViewController.swift
//  FirebaseChat
//
//  Created by Cora Jacobson on 10/3/20.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageViewController: MessagesViewController {
    
    var chatController: ChatController?
    var chatRoom: ChatRoom?
    var messages: [Message]?
    
    private lazy var formatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        result.timeStyle = .short
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages = sortMessagesByDate()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func sortMessagesByDate() -> [Message] {
        var sortedMessages: [Message] = []
        if let messages = chatRoom?.messages {
            sortedMessages = messages.sorted(by: {
                $0.sentDate.compare($1.sentDate) == .orderedAscending
            })
            }
        return sortedMessages
    }

}

extension MessageViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        if let currentUser = chatController?.currentUser {
            return currentUser
        } else {
            return Sender(senderId: "foo", displayName: "bar")
        }
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatRoom?.messages.count ?? 0
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let message = messages?[indexPath.item] else {
            fatalError("no message found in thread.")
        }
        return message
    }
    
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
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension MessageViewController: MessagesDisplayDelegate {
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .systemPurple : .systemTeal
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let initials = String(message.sender.displayName.first ?? Character(""))
        let avatar = Avatar(image: nil, initials: initials)
        avatarView.set(avatar: avatar)
    }
    
}

extension MessageViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let chatRoom = chatRoom,
              let currentSender = currentSender() as? Sender else { return }
        
        chatController?.createMessage(chatRoom: chatRoom, sender: currentSender, text: text)
        messages = sortMessagesByDate()
        self.messagesCollectionView.reloadData()
    }
}
