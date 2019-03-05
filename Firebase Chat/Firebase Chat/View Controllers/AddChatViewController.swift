//
//  AddChatViewController.swift
//  Firebase Chat
//
//  Created by Nelson Gonzalez on 3/5/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import Firebase

class AddChatViewController: UIViewController {
    
    @IBOutlet weak var chatNameTextField: UITextField!
    
    var chatsController: ChatsController?
    

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let chatName = chatNameTextField.text, !chatName.isEmpty else {return}
        
        chatsController?.uploadDataToServer(chatName: chatName, onSuccess: {
            self.navigationController?.popViewController(animated: true)
        })
       
        
    }
    

}
