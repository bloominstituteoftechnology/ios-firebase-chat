//
//  ChatTableViewController.swift
//  FirebaseChat
//
//  Created by Sal B Amer on 4/24/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomMainTableViewController: UITableViewController {
    
    let messageController = MessageController()
    
    //IBOUTLETS
    @IBOutlet weak var chatRoomTitle: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // add bar button to create new chatRoom
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChatRoom))
        messageController.fetchChatRoom {
            self.tableView.reloadData()
        }
      }
    // Creates a new chatroom
       @objc private func addChatRoom() {
           let alert = UIAlertController(title: "Create a new Chatroom", message: "Enter the Chatroom name and hit OK", preferredStyle: .alert)
           alert.addTextField()
           alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let textField = alert.textFields?.first, let name = textField.text, !name.isEmpty else { return }
            self.messageController.addChatRoom(with: name) {
                self.messageController.fetchChatRoom {
                       self.dismiss(animated: true)
                       self.tableView.reloadData()
                   }
               }
           })
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
           self.present(alert, animated: true)
       }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messageController.rooms.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        let room = messageController.rooms[indexPath.row]
        cell.textLabel?.text = room.name
        
        return cell
    }


 
    
    
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ChatDetailViewController else { return }
            
            let room = messageController.rooms[indexPath.row]
            destinationVC.messageController = messageController
            destinationVC.room = room
        }
    }

}
