//
//  ChatRoomTableViewController.swift
//  iOS Firebase Chat
//
//  Created by Dillon McElhinney on 10/23/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MessageKit

class ChatRoomTableViewController: UITableViewController {
    
    // MARK: - Properties
    lazy var firebaseController: FirebaseContoller! = {
        return FirebaseContoller()
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "Username") == nil {
            
            presentNameAlert()
        } else {
            guard let displayName = UserDefaults.standard.string(forKey: "Username"),
                let id = UserDefaults.standard.string(forKey: "UserID") else { return }
            firebaseController.currentSender = Sender(id: id, displayName: displayName)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        firebaseController.loadChatrooms { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UI Actions
    @IBAction func addChatRoom(_ sender: Any) {
        presentAddChatRoomAlert()
    }
    

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseController.chatrooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        let chatroom = firebaseController.chatrooms[indexPath.row]

        cell.textLabel?.text = chatroom.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            firebaseController.deleteChatroom(with: indexPath)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChatRoomSegue" {
            let destinationVC = segue.destination as! MessageViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let chatroom = firebaseController.chatrooms[indexPath.row]
            
            destinationVC.firebaseController = firebaseController
            destinationVC.chatroom = chatroom
            firebaseController.closeChatrooms()
        }
    }
    
    // MARK: - Utility Methods
    private func presentAddChatRoomAlert() {
        let alert = UIAlertController(title: "Add Chatroom?", message: nil, preferredStyle: .alert)
        
        var titleTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Your Cool New Chatroom"
            
            titleTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            self.firebaseController.makeNewChatRoom(with: titleTextField?.text ?? "New Chatroom")
        }
        alert.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    private func presentNameAlert() {
        let alert = UIAlertController(title: "What Is Your Name?", message: nil, preferredStyle: .alert)
        
        var nameTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Your Name"
            
            nameTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            let name = nameTextField?.text ?? "Some Person"
            let id = UUID().uuidString
            UserDefaults.standard.set(name, forKey: "Username")
            UserDefaults.standard.set(id, forKey: "UserID")
            
            self.firebaseController.currentSender = Sender(id: id, displayName: name)
        }
        alert.addAction(submitAction)
        
        present(alert, animated: true)
    }

}
