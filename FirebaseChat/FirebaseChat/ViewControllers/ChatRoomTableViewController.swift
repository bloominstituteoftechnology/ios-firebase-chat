//
//  ChatRoomTableViewController.swift
//  FirebaseChat
//
//  Created by Cora Jacobson on 10/3/20.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {
    
    let chatController = ChatController()

    @IBOutlet weak var ChatTitleTextField: UITextField!
    @IBOutlet weak var usernameButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUserDictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String : String] {
            let currentUser = Sender(dictionary: currentUserDictionary)
            chatController.currentUser = currentUser
            usernameButton.title = currentUser?.displayName
        } else {
            setCurrentUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatController.fetchEverything {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatController.chatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)

        cell.textLabel?.text = chatController.chatRooms[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            chatController.deleteChatRoom(chatRoom: chatController.chatRooms[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMessageSegue" {
            if let messageVC = segue.destination as? MessageViewController,
               let index = tableView.indexPathForSelectedRow?.row {
                messageVC.chatController = chatController
                messageVC.chatRoom = chatController.chatRooms[index]
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func createChatRoom(_ sender: UITextField) {
        ChatTitleTextField.resignFirstResponder()
        guard let title = ChatTitleTextField.text else { return }
        ChatTitleTextField.text = ""
        chatController.createChatRoom(title: title)
        self.tableView.reloadData()
    }
    
    @IBAction func changeUsername(_ sender: UIBarButtonItem) {
        setCurrentUser()
    }
    
    func setCurrentUser() {
        let alert = UIAlertController(title: "Set a username", message: nil, preferredStyle: .alert)
        var userNameTextFiled: UITextField!
        alert.addTextField { (textField) in
            textField.placeholder = "Username:"
            userNameTextFiled = textField
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            let displayName = userNameTextFiled.text ?? "No name"
            let id = UUID().uuidString
            let sender = Sender(senderId: id, displayName: displayName)
            UserDefaults.standard.set(sender.dictionaryRepresentation, forKey: "currentUser")
            self.chatController.currentUser = sender
            self.usernameButton.title = sender.displayName
        }
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
}
