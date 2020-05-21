//
//  ChatRoomTableViewController.swift
//  Chat
//
//  Created by Chris Dobek on 5/21/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {
    
    //MARK: -Properties
    let chatRoomController = ChatRoomController()
    
    @IBOutlet var chatRoomTitleTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatRoomController.fetchChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.chatRoomController.currentUser == nil {
            let alert = UIAlertController(title: "Set a username", message: nil, preferredStyle: .alert)
            
            var usernameTextField: UITextField!
            alert.addTextField { (textField) in
                usernameTextField = textField
                textField.placeholder = "Username:"
            }
            
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
                let displayName = usernameTextField.text ?? "No name"
                let id = UUID().uuidString
                
                let sender = Sender(senderId: id, displayName: displayName)
                
                self.chatRoomController.currentUser = sender
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions
    @IBAction func createChatRoom(_ sender: Any) {
        chatRoomTitleTextField.resignFirstResponder()
        
        guard let chatRoomTitle = chatRoomTitleTextField.text else { return }
        
        chatRoomTitleTextField.text = ""
        
        chatRoomController.createChatRoom(with: chatRoomTitle) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomController.chatRooms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        
        cell.textLabel?.text = chatRoomController.chatRooms[indexPath.row].title

        return cell
    }
   

    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "ViewMessageThread" {
               guard let indexPath = tableView.indexPathForSelectedRow,
                   let destinationVC = segue.destination as? MessageViewController else { return }
               
               destinationVC.chatRoomController = chatRoomController
               destinationVC.chatRoom = chatRoomController.chatRooms[indexPath.row]
           }
    }
}
