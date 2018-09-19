//
//  ChatRoomTableViewController.swift
//  Firebase Chat
//
//  Created by Lisa Sampson on 9/18/18.
//  Copyright © 2018 Lisa Sampson. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatRoomTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        firebaseChatController.fetchChatRoom {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseChatController.chatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        cell.textLabel?.text = firebaseChatController.chatRooms[indexPath.row].chatRoom

        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDetailView" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MessagesDetailViewController else { return }
            
            destinationVC.firebaseChatController = firebaseChatController
            destinationVC.chatRoom = firebaseChatController.chatRooms[indexPath.row]
        }
    }

    let firebaseChatController = FirebaseChatController(ref: Database.database().reference())
}
