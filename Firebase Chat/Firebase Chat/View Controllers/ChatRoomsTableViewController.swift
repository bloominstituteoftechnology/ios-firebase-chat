//
//  ChatRoomsTableViewController.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

class ChatRoomsTableViewController: UITableViewController {
    
    // MARK: - Properties

    let chatRoomController = ChatRoomController()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        chatRoomController.createChatRoom(titled: "Initial Chat Room") {
//            self.tableView.reloadData()
//        }
        chatRoomController.fetchChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatRoomController.currentUser = Sender(senderId: "testUserID-555", displayName: "MissingNo.")
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomController.chatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        cell.textLabel?.text = chatRoomController.chatRooms[indexPath.row].title

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChatSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let chatVC = segue.destination as? ChatViewController else { return }
            
            chatVC.chatRoomController = chatRoomController
            chatVC.chatRoom = chatRoomController.chatRooms[indexPath.row]
            
        } else if segue.identifier == "ShowAddChatRoomSegue" {
            guard let addChatVC = segue.destination as? AddChatRoomViewController else { return }
            
            addChatVC.delegate = self
        }
    }

}

extension ChatRoomsTableViewController: AddChatRoomVCDelegate {
    func createdChatRoom(titled title: String) {
        chatRoomController.createChatRoom(titled: title) {
            self.tableView.reloadData()
        }
    }
}
