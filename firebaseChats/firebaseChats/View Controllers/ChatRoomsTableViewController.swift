//
//  ChatRoomsTableViewController.swift
//  firebaseChats
//
//  Created by Jesse Ruiz on 11/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomsTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var chatTextField: UITextField!
    
    // MARK: - Properties
    
    let chatRoomsController = ChatRoomsController()
    
    var ref: DatabaseReference! = Database.database().reference()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUserDictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String : String] {
            let currentUser = Sender(dictionary: currentUserDictionary)
            chatRoomsController.currentUser = currentUser
        } else {
            
            let alert = UIAlertController(title: "Set a username", message: nil, preferredStyle: .alert)
            
            var usernameTextField: UITextField!
            
            alert.addTextField { (textField) in
                textField.placeholder = "Username:"
                usernameTextField = textField
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
                
                let displayName = usernameTextField.text ?? "Unknown User"
                let id = UUID().uuidString
                
                let sender = Sender(senderId: id, displayName: displayName)
                
                UserDefaults.standard.set(sender.dictionaryRepresentation, forKey: "currentUser")
                
                self.chatRoomsController.currentUser = sender
            }
            
            alert.addAction(submitAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatRoomsController.fetchChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func createChat(_ sender: Any) {
        chatTextField.resignFirstResponder()
        
        guard let chatTitle = chatTextField.text else { return }
        
        chatTextField.text = ""
        
        chatRoomsController.createChatRoom(with: chatTitle) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return chatRoomsController.chatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        cell.textLabel?.text = chatRoomsController.chatRooms[indexPath.row].title

        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMessageSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as?
                MessageViewController else { return }
            
            destinationVC.chatRoomController = chatRoomsController
            destinationVC.chatRoom = chatRoomsController.chatRooms[indexPath.row]
        }
    }
}
