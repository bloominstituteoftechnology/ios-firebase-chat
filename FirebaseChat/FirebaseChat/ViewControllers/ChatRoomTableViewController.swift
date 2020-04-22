//
//  ChatRoomTableViewController.swift
//  FirebaseChat
//
//  Created by Shawn Gee on 4/21/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {

    private var chatRoomController = ChatRoomController()

    override func viewDidLoad() {
        super.viewDidLoad()
        chatRoomController.chatRoomsDidSet = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        chatRoomController.createChatRoom(name: "B Testing")
    }

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatRoomController.chatRooms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        cell.textLabel?.text = chatRoomController.chatRooms[indexPath.row].name

        return cell
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
