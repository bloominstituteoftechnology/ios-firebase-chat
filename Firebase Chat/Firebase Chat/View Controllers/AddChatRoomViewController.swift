//
//  AddChatRoomViewController.swift
//  Firebase Chat
//
//  Created by David Wright on 4/26/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

protocol AddChatRoomVCDelegate {
    func createdChatRoom(titled title: String)
}

class AddChatRoomViewController: UIViewController {

    var delegate: AddChatRoomVCDelegate!
    
    @IBOutlet weak var chatRoomTitleTextField: UITextField!
    
    @IBAction func createChatRoomButtonTapped(_ sender: UIButton) {
        guard let title = chatRoomTitleTextField.text,
            title != "" else { return }
        
        delegate.createdChatRoom(titled: title)
        navigationController?.popViewController(animated: true)
    }
}
