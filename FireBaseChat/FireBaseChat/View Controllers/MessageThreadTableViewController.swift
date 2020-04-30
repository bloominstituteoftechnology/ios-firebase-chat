//
//  MessageThreadTableViewController.swift
//  FireBaseChat
//
//  Created by Rachael Cedeno on 4/27/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import UIKit

class MessageThreadsTableViewController: UITableViewController {

        // MARK: - Properties
        
        let messageThreadController = MessageThreadController()
        
        @IBOutlet weak var threadTitleTextField: UITextField!

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            messageThreadController.fetchMessageThreads {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        // MARK: - Actions
        
        @IBAction func createThread(_ sender: Any) {
            threadTitleTextField.resignFirstResponder()
            
            guard let threadTitle = threadTitleTextField.text else { return }
            
            threadTitleTextField.text = ""
            
            messageThreadController.createMessageThread(with: threadTitle) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        // MARK: - UITableViewDataSource
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return messageThreadController.messageThreads.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageThreadCell", for: indexPath)
            
            cell.textLabel?.text = messageThreadController.messageThreads[indexPath.row].title

            return cell
        }
        
        // MARK: - Navigation

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ViewMessageThread" {
                guard let indexPath = tableView.indexPathForSelectedRow,
                    let destinationVC = segue.destination as? MessageThreadDetailTableViewController else { return }
                
                destinationVC.messageThreadController = messageThreadController
                destinationVC.messageThread = messageThreadController.messageThreads[indexPath.row]
            }
        }
        
    }
