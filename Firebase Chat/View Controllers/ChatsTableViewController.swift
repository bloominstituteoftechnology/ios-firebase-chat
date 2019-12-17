//
//  ChatsTableViewController.swift
//  Firebase Chat
//
//  Created by macbook on 11/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import MessageKit

class ChatsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var chatController = ChatController()
    
    @IBOutlet weak var newChatRoomTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUserDictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String : String ] {
            
            let currentUser = Sender(dictionary: currentUserDictionary)
            chatController.currentUser = currentUser
            
        } else {
            
            // An alert that asks the user for a username and saves it to UserDefaults
            let alert = UIAlertController(title: "What's your username? ", message: nil, preferredStyle: .alert)
            
            var userNameTextField: UITextField!
            
            alert.addTextField { (textField) in
                textField.placeholder = "Username:"
                userNameTextField = textField
                
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) {
                (_) in
                
                // Take the text field's text and save it to UD.

                let displayName = userNameTextField.text ?? "Unknown user"
                let id = UUID().uuidString
                
                let sender = Sender(senderId: id, displayName: displayName)
                
                UserDefaults.standard.set(sender.dictionaryRepresentation, forKey: "currentUser")
                
                self.chatController.currentUser = sender
            }
            
            alert.addAction(submitAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatController.fetchChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    
    @IBAction func createChatRoom(_ sender: UITextField) {
        newChatRoomTextField.resignFirstResponder()
        
        guard let chatRoomTitle = newChatRoomTextField.text else { return }
        
        newChatRoomTextField.text = ""
        
        chatController.createChatRoom(with: chatRoomTitle) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatController.chatRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        
        cell.textLabel?.text = chatController.chatRooms[indexPath.row].title
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMessagesSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MessagesDetailViewController else { return }
            
            destinationVC.chatController = chatController
            destinationVC.chatRoom = chatController.chatRooms[indexPath.row]
        }
    }
}



