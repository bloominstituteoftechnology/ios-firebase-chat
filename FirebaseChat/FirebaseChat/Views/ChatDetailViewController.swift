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
import Firebase

 
class ChatDetailViewController: MessagesViewController {
    
    //  Variables
    var room: ChatRoom?
    var messageController: MessageController?
    var messages = [Message]()


    @IBOutlet weak var enterNameTxtField: UITextField!
    @IBOutlet weak var textMessageTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    // IB Action
    @IBAction func sendBtnWasPressed(_ sender: UIButton) {
        guard let senderName = enterNameTxtField.text,
            let messageText = textMessageTextView.text,
            let messageThread = room else { return }
        
        messageController?.addNewMessageinRoom(messageThread, message: messageText, completion: {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })

        }
}


