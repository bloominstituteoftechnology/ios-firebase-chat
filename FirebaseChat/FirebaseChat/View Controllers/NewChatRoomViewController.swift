//
//  NewChatRoomViewController.swift
//  FirebaseChat
//
//  Created by Rob Vance on 10/6/20.
//

import UIKit

class NewChatRoomViewController: UIViewController {

    var modController: ChatRoomController?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBOutlets -
    @IBOutlet weak var newChatRoomTextField: UITextField!
    

    // MARK: - IBActions -
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        guard let chatRoomName = newChatRoomTextField.text, !chatRoomName.isEmpty else { return }
        modController?.createChatRoom(chatRoomName)
        dismiss(animated: true, completion: nil)
    }
    
}
