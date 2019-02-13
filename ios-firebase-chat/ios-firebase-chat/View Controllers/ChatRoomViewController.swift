import Foundation
import UIKit
import MessageKit
import MessageInputBar
import FirebaseDatabase
import Firebase

class ChatRoomViewController: MessagesViewController, MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate, MessageInputBarDelegate {
    
    var chatRoomController: ChatRoomController?
    var chatRoom: ChatRoom?
    private lazy var formatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        result.timeStyle = .medium
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
    }

    func currentSender() -> Sender {
        guard let sender = chatRoomController?.currentUser else {
            return Sender(id: "", displayName: "Anonymous")
        }
        return sender
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender == currentSender()
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        guard let message = chatRoom?.messages[indexPath.row] else {
            fatalError("Message not available.")
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
        let name = message.sender.displayName
        let attrs = [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .caption1)]
        return NSAttributedString(string: name, attributes: attrs)
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        let attrs = [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .caption2)]
        return NSAttributedString(string: dateString, attributes: attrs)
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .purple : .orange
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
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        guard let chatRoom = chatRoom else { return }
        
        chatRoomController?.createMessage(in: chatRoom, withText: text, from: currentSender().displayName) {
            
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        }
    }
    
}
        

