//
//  ChatDetailViewController.swift
//  FirebaseChat
//
//  Created by Sal B Amer on 4/24/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
 

 
class ChatDetailViewController: MessagesViewController {
    
    //  Variables
    var chatRoom: ChatRoom?
    var messageController: MessageController?
    var messages = [Message]()


    @IBOutlet weak var enterNameTxtField: UITextField!
    @IBOutlet weak var textMessageTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    // IB Action to send message to ChatRoom // Not working
//    @IBAction func sendBtnWasPressed(_ sender: UIButton) {
//        guard let user = messageController?.currentUser else { return }
//        
//        guard let senderName = enterNameTxtField.text,
//            let messageText = textMessageTextView.text,
//            let chatRoom = chatRoom else { return }
//        
//        messageController?.addNewMessageinRoom(in: chatRoom, message: messageText, from: user, completion: {
//            DispatchQueue.main.async {
//                self.navigationController?.popViewController(animated: true)
//            }
//        })
//}
}



