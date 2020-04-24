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
        getUser()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView(_:)), name: .chatRoomsUpdated, object: nil)
    }
    
    @objc func updateTableView(_ notification: NSNotification) {
        tableView.reloadData()
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
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        self.tableView = tableView
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomController.chatRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        
        cell.textLabel?.text = chatRoomController.chatRooms[indexPath.row].name
        
        return cell
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
