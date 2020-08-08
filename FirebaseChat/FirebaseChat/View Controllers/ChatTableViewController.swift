//
//  ChatTableViewController.swift
//  FirebaseChat
//
//  Created by Morgan Smith on 8/7/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit
import MessageKit
import Firebase


class ChatTableViewController: UITableViewController {

    let messageController = MessageController()

    @IBOutlet weak var chatRoomTitleTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUserDictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String: String] {
            let currentUser = Sender(dictionary: currentUserDictionary)
            messageController.currentUser = currentUser
        } else {
            let alert = UIAlertController(title: "Set a username", message: nil, preferredStyle: .alert)

            var usernameTextField: UITextField!

            alert.addTextField { (textField) in
                textField.placeholder = "Username:"
                usernameTextField = textField
            }

            let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in

                // Take the text field's text and save it to UD.

                let displayName = usernameTextField.text ?? "No name"
                let id = UUID().uuidString

                let sender = Sender(senderId: id, displayName: displayName)

                UserDefaults.standard.set(sender.dictionaryRepresentation, forKey: "currentUser")

                self.messageController.currentUser = sender
            }

            alert.addAction(submitAction)
            present(alert, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        messageController.fetchMessageThreads {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func createChatRoom(_ sender: Any) {
        chatRoomTitleTextField.resignFirstResponder()
              guard let chatRoomTitle = chatRoomTitleTextField.text else { return }
              chatRoomTitleTextField.text = ""
              messageController.createMessageThread(with: chatRoomTitle) {
                  DispatchQueue.main.async {
                      self.tableView.reloadData()
                  }
              }
    }



    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageController.messageThreads.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        cell.textLabel?.text = messageController.messageThreads[indexPath.row].title

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessage" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MessageViewController else { return }
            destinationVC.messageController = messageController
            destinationVC.messageThread = messageController.messageThreads[indexPath.row]
        }
    }

}
