//
//  ConversationsViewController.swift
//  FirebaseChat
//
//  Created by Shawn James on 5/19/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit
import Firebase

class ConversationsViewController: UIViewController {
    
    // MARK: - Outlets & Properties
    @IBOutlet weak var newConversationTitleTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    let databaseReference = Database.database().reference()
    var conversations = [String]()
    var conversationReferences = [DatabaseReference]()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        createSenderIdIfNeeded()
        fetchNewConversations()
    }
    
    // MARK: - Actions & Methods
    @IBAction func addNewConversationButtonPressed(_ sender: UIButton) {
        newConversationTitleTextField.resignFirstResponder()
        guard let name = newConversationTitleTextField.text, !name.isEmpty else { return }
        databaseReference.child("Conversations").childByAutoId().setValue((["name" : name]))
        newConversationTitleTextField.text = ""
    }
    
    func fetchNewConversations() {
        databaseReference.child("Conversations").observe(.childAdded) { (dataSnapshot) in
            guard let name = dataSnapshot.childSnapshot(forPath: "name").value as? String else { return }
            self.conversationReferences.append(dataSnapshot.ref)
            self.conversations.append(name)
            self.tableView.reloadData()
        }
    }
    
    func createSenderIdIfNeeded() {
        guard UserDefaults.standard.string(forKey: "senderId") == nil else { return }
        
        // present alert to input & save username
        let alert = UIAlertController(title: "Set Your Username", message: nil, preferredStyle: .alert)
        var usernameTextField: UITextField!
        alert.addTextField { (textField) in
            usernameTextField = textField
            textField.placeholder = "Username:"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            let displayName = usernameTextField.text ?? "anonymous"
            let id = UUID().uuidString
            UserDefaults.standard.set(id, forKey: "senderId")
            UserDefaults.standard.set(displayName, forKey: "displayName")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowMessages", let indexPath = tableView.indexPathForSelectedRow else { return }
        let messageViewController = segue.destination as! MessageViewController
        messageViewController.conversation = conversations[indexPath.row]
        messageViewController.conversationReference = conversationReferences[indexPath.row]
    }
    
}

// MARK: - TableView data source
extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath)
        cell.textLabel?.text = conversations[indexPath.row]
        cell.detailTextLabel?.text = ""
        return cell
    }
    
}
