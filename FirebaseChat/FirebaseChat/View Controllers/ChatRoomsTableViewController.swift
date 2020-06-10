//
//  ChatRoomsTableViewController.swift
//  FirebaseChat
//
//  Created by Thomas Dye on 06/5/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit

class ChatRoomsTableViewController: UITableViewController {
    var chatController = ChatController()

    override func viewDidLoad() {
        super.viewDidLoad()
        chatController.fetchChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatController.chatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        cell.textLabel?.text = chatController.chatRooms[indexPath.row].title
        return cell
    }


}
