//
//  ChatRoomDetailViewController.swift
//  FirebaseChat
//
//  Created by Lambda_School_Loaner_268 on 3/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatRoomDetailViewController: MessagesViewController, InputBarAccessoryViewDelegate {
    
    var room: ChatRoom?
    var roomController: RoomController?
    var messageController = MessageController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        // Do any additional setup after loading the view.
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard let room = self.room, let currentSender = currentSender() as? Sender else { return }
        
        self.messageController.createMessage(in: room, with: text, sender: currentSender, completion: {
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
            }
        })
        inputBar.inputTextView.text = ""
    }
    
    override func viewWillAppear (_ animated: Bool) {
        guard let room = room,
            let index = roomController?.chatRooms.firstIndex(of: room) else { return }
        messageController.fetchMessages(in: room) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
            self.roomController!.chatRooms[index] = room
        }
    }
}

extension ChatRoomDetailViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return Sender(senderId: UUID().uuidString, displayName: "Unknown user")
    }
        
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let message = self.room!.messages[indexPath.item]
        return message
        }
        
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
        
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
            return self.room!.messages.count
        }
    }

extension ChatRoomDetailViewController: MessagesLayoutDelegate {
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
            return 16
        }
        
        func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
            return 16
        }
    }

extension ChatRoomDetailViewController: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .blue
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue : .green
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let initials = String(message.sender.displayName.first ?? Character("a"))
        let avatar = Avatar(image: nil, initials: initials)
        avatarView.set(avatar: avatar)
    }
}



