//
//  ChatRoomTableViewController.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {
    
    // MARK: - Private Properties
    
    private var chatRoomController = ChatRoomController()
    
    // MARK: - IBActions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        chatRoomController.createChatRoom(name: "Jon Testing")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = chatRoomController
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMessagesSegue",
            let chatRoomVC = segue.destination as? ChatRoomViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            let chatRoom = chatRoomController.chatRooms[indexPath.row]
            chatRoomVC.messageController = MessageController(chatRoom: chatRoom)
        }
    }
    
}
