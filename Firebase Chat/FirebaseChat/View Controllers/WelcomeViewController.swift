//
//  WelcomeViewController.swift
//  FirebaseChat
//
//  Created by Spencer Curtis on 9/18/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBAction func getChatting(_ sender: Any) {
        guard let text = usernameTextField.text, text != "" else {
            presentInformationalAlertController(title: "Error:", message: "Please enter a username into the field")
            return
        }
        
        SenderHelper.setCurrentSender(with: text)
        performSegue(withIdentifier: "ViewChatRooms", sender: nil)
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
}
