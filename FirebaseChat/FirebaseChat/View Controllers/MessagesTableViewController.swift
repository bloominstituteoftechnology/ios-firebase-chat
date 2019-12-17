//
//  MessagesTableViewController.swift
//  FirebaseChat
//
//  Created by Jon Bash on 2019-12-17.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit
import MessageKit

class MessagesTableViewController: UITableViewController {
    // MARK: - Properties
    
    var chatController = ChatController()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        chatController.attemptToLogIn { didSucceed in
            if !didSucceed {
                DispatchQueue.main.async { self.showNewUserAlert() }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatController.fetchChatrooms { result in
            do {
                let _ = try result.get()
                DispatchQueue.main.async { self.tableView.reloadData() }
            } catch {
                NSLog("Error fetching chatrooms: \(error)")
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return chatController.chatrooms.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChatRoomCell",
            for: indexPath)

        cell.textLabel?.text = chatController.chatrooms[indexPath.row].name

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChatRoomDetailSegue" {
            guard
                let roomVC = segue.destination as? ChatroomViewController,
                let index = tableView.indexPathForSelectedRow?.row
                else { return }
            roomVC.chatController = chatController
            roomVC.chatroom = chatController.chatrooms[index]
        }
        if segue.identifier == "NewChatRoomSegue" {
            guard
                let roomVC = segue.destination as? ChatroomViewController
                else { return }
            roomVC.chatController = chatController
        }
    }
    
    // MARK: - Helper Methods

    private func showNewUserAlert() {
        let alert = UIAlertController(
            title: "Set a username",
            message: nil,
            preferredStyle: .alert)
        
        var usernameTextField: UITextField!
        
        alert.addTextField { (textField) in
            textField.placeholder = "Username:"
            usernameTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            let displayName = usernameTextField.text ?? "No name"
            let id = UUID().uuidString
            
            let sender = Sender(senderId: id, displayName: displayName)
            
            UserDefaults.standard.set(sender.dictionaryRepresentation, forKey: "currentUser")
            
            self.chatController.login(with: sender)
        }

        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
}
