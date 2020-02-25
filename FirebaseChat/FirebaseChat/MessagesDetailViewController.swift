//
//  MessagesDetailViewController.swift
//  FirebaseChat
//
//  Created by Jorge Alvarez on 2/25/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import MessageKit

class MessagesDetailViewController: MessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate = self
        // Do any additional setup after loading the view.
    }

}

//extension MessagesDetailViewController: MessagesDataSource {
//
//    func currentSender() -> SenderType {
//        <#code#>
//    }
//
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//        <#code#>
//    }
//
//    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//        <#code#>
//    }
//}
//
//extension MessagesDetailViewController: MessagesLayoutDelegate {
//    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 16
//    }
//
//    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 16
//    }
//}
//
//extension MessagesDetailViewController: MessagesDisplayDelegate {
//
//}


/*
 import UIKit
 import MessageKit

 class MessageThreadDetailViewController: MessagesViewController {

     var messageThreadController: MessageThreadController?
     var messageThread: MessageThread?
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         messagesCollectionView.messagesDataSource = self
         messagesCollectionView.messagesLayoutDelegate = self
         messagesCollectionView.messagesDisplayDelegate = self
     }
     
     private lazy var formatter: DateFormatter = {
         let result = DateFormatter()
         result.dateStyle = .medium
         return result
     }()
 }

 extension MessageThreadDetailViewController: MessagesDataSource {
     // MARK - Required
     func currentSender() -> SenderType {
         if let currentUser = messageThreadController?.currentUser {
             return currentUser
         } else {
             return Sender(senderId: UUID().uuidString, displayName: "Unknown User")
         }
     }
     
     func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
         guard let message = messageThread?.messages[indexPath.item] else {
             // DONT DO IT
             fatalError("No message in thread")
         }
         return message
     }
     
     func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
         return 1
     }
     
     // MARK - Optional
     func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
         return messageThread?.messages.count ?? 0
     }
     
     func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
         let name = message.sender.displayName
         let attrs = [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: .caption1)]
         return NSAttributedString(string: name, attributes: attrs)
     }
 }

 extension MessageThreadDetailViewController: MessagesLayoutDelegate {
     func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
         return 16
     }
     
     func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
         return 16
     }
 }

 extension MessageThreadDetailViewController: MessagesDisplayDelegate {
     
 }

 */
