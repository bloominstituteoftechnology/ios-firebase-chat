//
//  ChatRoomViewController.swift
//  FirebaseChat
//
//  Created by Rob Vance on 10/2/20.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatRoomViewController: MessagesViewController {
    
    var chatRoom: ChatRoom!
    var modController: ChatRoomController?
    
    private var messages: [Message] = [] {
        didSet {
            messagesCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = chatRoom?.name
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        loadMessages()
    }
    
    private let sender = Sender(senderId: UUID().uuidString, displayName: "Rob")
    
    private func loadMessages() {
        modController?.fetchMessagesInChatRoom(chatRoom) { messages in
            self.messages = messages
        }
    }

}
extension ChatRoomViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
}
extension ChatRoomViewController: MessagesLayoutDelegate {
    
}

extension ChatRoomViewController: MessagesDisplayDelegate {
    
}

extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        modController?.createMessageInChatRoom(message: Message(text: text), chatRoom: chatRoom)
        inputBar.inputTextView.text = nil
        loadMessages()
    }
}
