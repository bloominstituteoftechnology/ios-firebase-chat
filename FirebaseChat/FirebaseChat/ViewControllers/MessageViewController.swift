//
//  MessageViewController.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    // MARK: - Properties
    
    var chatRoom: ChatRoom?
    var messageController: MessageController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let chatRoom = chatRoom else { return }
        messageController = MessageController(chatRoom: chatRoom)
    }
}
