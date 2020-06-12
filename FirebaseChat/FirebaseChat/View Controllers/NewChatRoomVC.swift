//
//  NewChatRoomVC.swift
//  FirebaseChat
//
//  Created by Chad Parker on 2020-06-09.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit

class NewChatRoomVC: UIViewController {
   
   var modelController: ModelController!
   
   @IBOutlet weak var newChatRoomTextField: UITextField!
   
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   @IBAction func cancel(_ sender: Any) {
      dismiss(animated: true, completion: nil)
   }
   
   @IBAction func done(_ sender: Any) {
      guard let chatRoomName = newChatRoomTextField.text, !chatRoomName.isEmpty else { return }
      modelController.createChatRoom(chatRoomName)
      dismiss(animated: true, completion: nil)
   }
}
