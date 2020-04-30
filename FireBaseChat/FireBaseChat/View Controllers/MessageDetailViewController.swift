//
//  MessageDetailViewController.swift
//  FireBaseChat
//
//  Created by Rachael Cedeno on 4/27/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

      // MARK: - Properties
        
        var messageThreadController: MessageThreadController?
        var messageThread: MessageThread?
        
        @IBOutlet weak var senderNameTextField: UITextField!
        @IBOutlet weak var messageTextView: UITextView!

        // MARK: - Actions
        
        @IBAction func sendMessage(_ sender: Any) {
            
            guard let senderName = senderNameTextField.text,
                let messageText = messageTextView.text,
                let messageThread = messageThread else { return }
            
            messageThreadController?.createMessage(in: messageThread, withText: messageText, sender: senderName, completion: {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }

    }
