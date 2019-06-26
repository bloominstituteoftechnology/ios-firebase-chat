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

        chatRoomController.fetchChatRooms()

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    let chatRoomController = ChatRoomController()
}
