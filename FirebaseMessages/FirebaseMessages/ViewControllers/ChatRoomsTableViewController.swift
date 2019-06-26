//
//  ChatRoomsTableViewController.swift
//  FirebaseMessages
//
//  Created by Jonathan Ferrer on 6/25/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit
import MessageKit
class ChatRoomsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        chatRoomController.createChatRoom(name: "Another Thread")
        chatRoomController.createMessage(chatRoom: chatRoomController.chatRooms[0], text: "SomeText", user: Sender(id: "ASDFASDfas", displayName: "Jon"))
        chatRoomController.createMessage(chatRoom: chatRoomController.chatRooms[0], text: "Some More Text", user: Sender(id: "ASDFASDfas", displayName: "Jon"))

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatRoomController.chatRooms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        let chatRoom = chatRoomController.chatRooms[indexPath.row]

        cell.textLabel?.text = chatRoom.name

        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewChatRoom" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MessageViewController else { return }

            destinationVC.chatRoomController = chatRoomController
            destinationVC.chatRoom = chatRoomController.chatRooms[indexPath.row]
        }
    }
    let chatRoomController = ChatRoomController()
}
