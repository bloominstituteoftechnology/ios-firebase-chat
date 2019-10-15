//
//  MessageBoardViewController.swift
//  FirebaseChat
//
//  Created by Jake Connerly on 10/15/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageBoardViewController: MessagesViewController {
    
    // MARK: - Properties
    
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MessageBoardViewController: InputBarAccessoryViewDelegate {
    
}
