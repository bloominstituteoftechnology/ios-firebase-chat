//
//  ChatRoomsTableViewController.swift
//  FirebaseChat
//
//  Created by Gi Pyo Kim on 11/12/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class ChatRoomsTableViewController: UITableViewController {
    @IBOutlet weak var chatRoomTextField: UITextField!
    
    let chatRoomController = ChatRoomController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUserDictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String: String] {
            let currentUser = Sender(dictionary: currentUserDictionary)
            chatRoomController.currentUser = currentUser
        } else {
            let alert = UIAlertController(title: "Set a username", message: nil, preferredStyle: .alert)
            
            var usernameTextField: UITextField!
            
            alert.addTextField { (textField) in
                textField.placeholder = "Username:"
                usernameTextField = textField
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
                let displayName = usernameTextField.text ?? "Unknown user"
                let id = UUID().uuidString
                
                let sender = Sender(senderId: id, displayName: displayName)
                
                UserDefaults.standard.set(sender.dictionaryRepresentation, forKey: "currentUser")
                
                self.chatRoomController.currentUser = sender
            }
            
            alert.addAction(submitAction)
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        chatRoomController.fetchChatRooms() {
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMessage" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let messageVC = segue.destination as? MessageViewController else { return }
            
            messageVC.chatRoomController = chatRoomController
            messageVC.chatRoom = chatRoomController.chatRooms[indexPath.row]
        }
    }

    @IBAction func createNewChatRoom(_ sender: Any) {
        chatRoomTextField.resignFirstResponder()
        
        guard let chatRoomTitle = chatRoomTextField.text else { return }
        
        chatRoomTextField.text = ""
        
        chatRoomController.createChatRoom(title: chatRoomTitle) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
