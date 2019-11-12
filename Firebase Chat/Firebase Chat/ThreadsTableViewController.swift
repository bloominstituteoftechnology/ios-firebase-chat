//
//  ThreadsTableViewController.swift
//  Firebase Chat
//
//  Created by Isaac Lyons on 11/12/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ThreadsTableViewController: UITableViewController {
    
    //MARK: Properties
    
    let messageThreadController = MessageThreadController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let currentUserDictionary = UserDefaults.standard.value(forKey: "CurrentSender") as? [String: String] {
            let currentUser = Sender(from: currentUserDictionary)
            messageThreadController.currentSender = currentUser
        } else {
            let alert = UIAlertController(title: "Set a display name", message: nil, preferredStyle: .alert)
            
            var usernameTextField: UITextField!
            
            alert.addTextField { textField in
                textField.placeholder = "Display name"
                usernameTextField = textField
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
                let displayName = usernameTextField.text ?? "Unknown sender"
                let id = UUID().uuidString
                
                let sender = Sender(senderId: id, displayName: displayName)
                
                UserDefaults.standard.set(sender.dictionaryRepresentation, forKey: "CurrentSender")
                
                self.messageThreadController.currentSender = sender
            }
            
            alert.addAction(submitAction)
            present(alert, animated: true, completion: nil)
        }
        
        messageThreadController.fetchThreads {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageThreadController.threads.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadCell", for: indexPath)

        cell.textLabel?.text = messageThreadController.threads[indexPath.row].title

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let threadVC = segue.destination as? ThreadViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            threadVC.messageThreadController = messageThreadController
            threadVC.messageThread = messageThreadController.threads[indexPath.row]
        }
    }
    
    //MARK: Actions
    
    @IBAction func createThread(_ sender: UITextField) {
        sender.resignFirstResponder()
        guard let title = sender.text else { return }
        sender.text = ""
        
        messageThreadController.createMessageThread(title: title)
        
        tableView.reloadData()
    }
    
}
