//
//  ChatRoomsTableViewController.swift
//  FirebaseChat
//
//  Created by Spencer Curtis on 9/18/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class ChatRoomsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews), name: .roomsWereUpdated, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatRoomController.fetchRooms()
    }
    
    @objc func refreshViews() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomController.rooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        let room = chatRoomController.rooms[indexPath.row]
        cell.textLabel?.text = room.name

        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewChatRoom" {
            guard let indexPath = tableView.indexPathForSelectedRow,
               let destinationVC = segue.destination as? ChatRoomDetailViewController else { return }
            
            let room = chatRoomController.rooms[indexPath.row]
            
            destinationVC.room = room
            destinationVC.messageController = messageController
        }
    }
    
    @IBAction func addChatRoom(_ sender: Any) {
        let alert = UIAlertController(title: "New Chat Room", message: "Enter a name for the new chat room:", preferredStyle: .alert)
        
        var nameTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Chat room name:"
            nameTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let name = nameTextField?.text else { return }
            self.chatRoomController.createRoomWith(name: name)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    let chatRoomController = ChatRoomController()
    let messageController = MessageController()
}
