//
//  ChatRoomTableViewController.swift
//  Firebase Chat
//
//  Created by Lisa Sampson on 9/18/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import UIKit
import Firebase
import MessageKit

class ChatRoomTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        firebaseChatController.fetchChatRoom {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        let alert = UIAlertController(title: "Set a username", message: nil, preferredStyle: .alert)
        var nameTextField: UITextField?
        alert.addTextField { (textField) in
            textField.placeholder = "Username"
            nameTextField = textField
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            let user = Sender(id: UUID().uuidString, displayName: nameTextField?.text ?? "User")
            self.firebaseChatController.currentUser = user
        }
        alert.addAction(submitAction)
        
        present(alert, animated: true, completion: nil)
    }

    @IBAction func createChatRoom(_ sender: Any) {
        chatRoomTextField.resignFirstResponder()
        
        guard let chatTitle = chatRoomTextField.text else { return }
        
        chatRoomTextField.text = ""
        
        firebaseChatController.createChatRoom(chatRoom: chatTitle)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseChatController.chatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        cell.textLabel?.text = firebaseChatController.chatRooms[indexPath.row].chatRoom

        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailView" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MessagesDetailViewController else { return }
            
            destinationVC.firebaseChatController = firebaseChatController
            destinationVC.chatRoom = firebaseChatController.chatRooms[indexPath.row]
        }
    }

    @IBOutlet weak var chatRoomTextField: UITextField!
    let firebaseChatController = FirebaseChatController(ref: Database.database().reference())
}
