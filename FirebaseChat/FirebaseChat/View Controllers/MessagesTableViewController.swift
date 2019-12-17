//
//  MessagesTableViewController.swift
//  FirebaseChat
//
//  Created by Jon Bash on 2019-12-17.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit

class MessagesTableViewController: UITableViewController {

    var chatController = ChatController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatController.fetchChatrooms { result in
            do {
                let _ = try result.get()
                DispatchQueue.main.async { self.tableView.reloadData() }
            } catch {
                NSLog("Error fetching chatrooms: \(error)")
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return chatController.chatrooms.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChatRoomCell",
            for: indexPath)

        cell.textLabel?.text = chatController.chatrooms[indexPath.row].name

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChatRoomDetailSegue" {
            guard
                let roomVC = segue.destination as? ChatroomViewController,
                let index = tableView.indexPathForSelectedRow?.row
                else { return }
            roomVC.chatController = chatController
            roomVC.chatroom = chatController.chatrooms[index]
        }
    }
}
