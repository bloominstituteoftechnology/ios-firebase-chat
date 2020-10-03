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
    
    var chatRoom: ChatRoom?
    
    private var messages: [Message] = [] {
        didSet {
            messagesCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
extension ChatRoomViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        <#code#>
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        <#code#>
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        <#code#>
    }
    
    
}
