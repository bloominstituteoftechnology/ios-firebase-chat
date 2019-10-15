//
//  ChatRoomViewController.swift
//  FirebaseChat
//
//  Created by Jake Connerly on 10/15/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties

    @IBOutlet weak var tableView: UITableView!
    let messageThreadController = MessageThreadController()
    
    @IBOutlet weak var newThreadTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUserDictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String : String] {
            let currentUser = Sender(dictionary: currentUserDictionary)
            messageThreadController.currentUser = currentUser
        } else {
            // Create an alert that asks the user for a username and saves it to User Defaults
            let alert = UIAlertController(title: "Set a username", message: nil, preferredStyle: .alert)
            var usernameTextField: UITextField!
            
            alert.addTextField { (textfield) in
                textfield.placeholder = "Username:"
                usernameTextField = textfield
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
                // Take the text field's text and save to User Defaults
                let displayName = usernameTextField.text ?? "No name"
                let id = UUID().uuidString
                let sender = Sender(senderId: id, displayName: displayName)
                
                UserDefaults.standard.set(sender.dictionaryRepresentation, forKey: "currentUser")
                self.messageThreadController.currentUser = sender
            }
            
            alert.addAction(submitAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        messageThreadController.fetchMessageThreads {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func createThread(_ sender: UITextField) {
        newThreadTextField.resignFirstResponder()
        
        guard let threadTitle = newThreadTextField.text else { return }
        
        newThreadTextField.text = ""
        
        messageThreadController.createMessageThread(with: threadTitle) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessageDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MessageBoardViewController else { return }
            
            destinationVC.messageThreadController = messageThreadController
            destinationVC.messageThread = messageThreadController.messageThreads[indexPath.row]
        }
    }

}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageThreadController.messageThreads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageThreadCell", for: indexPath)
        
        cell.textLabel?.text = messageThreadController.messageThreads[indexPath.row].title

        return cell
    }
    
    
}
