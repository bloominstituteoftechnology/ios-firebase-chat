//
//  ChatRoomTableViewController.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {
    
    // MARK: - Private Properties
    
    private var chatRoomController = ChatRoomController()
    
    // MARK: - IBActions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        chatRoomController.createChatRoom(name: "Jon Testing")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = chatRoomController
        
        getUser()
    }
    
    func getUser() {
        if let currentUserDictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String: String], let currentUser = User(with: currentUserDictionary) {
            self.chatRoomController.currentUser = currentUser
        } else {
            let alert = UIAlertController(title: "Set a username", message: nil, preferredStyle: .alert)
            var usernameTextField: UITextField!
            alert.addTextField { (textfield) in
                textfield.placeholder = "Username:"
                usernameTextField = textfield
            }
            
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
                let displayName = usernameTextField.text ?? "No name"
                let id = UUID().uuidString
                
                let user = User(id: id, displayName: displayName)
                UserDefaults.standard.set(user.dictionaryRepresentation, forKey: "currentUser")
                self.chatRoomController.currentUser = user
            }))
            
            present(alert, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMessagesSegue",
            let chatRoomVC = segue.destination as? ChatRoomViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            let chatRoom = chatRoomController.chatRooms[indexPath.row]
            chatRoomVC.messageController = MessageController(chatRoom: chatRoom)
            chatRoomVC.messageController.currentUser = chatRoomController.currentUser
        }
    }
    
}
