//
//  ChatRoomTableViewController.swift
//  iOS Firebase Chat
//
//  Created by Dillon McElhinney on 10/23/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MessageKit

class ChatRoomTableViewController: UITableViewController {
    
    // MARK: - Properties
    lazy var firebaseController: FirebaseContoller! = {
        return FirebaseContoller()
    }()
    
    var authHandle: AuthStateDidChangeListenerHandle!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("\(user.displayName ?? "no name") - \(user.email ?? "no email") is logged in.")
                self.firebaseController.currentSender = Sender(id: user.uid, displayName: user.displayName ?? user.email ?? "Some person")
            } else {
                self.dismiss(animated: true)
            }
        }
        
        firebaseController.loadChatrooms { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(authHandle!)
    }
    
    // MARK: - UI Actions
    @IBAction func addChatRoom(_ sender: Any) {
        presentAddChatRoomAlert()
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            NSLog("Error logging out: \(error)")
        }
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
}
