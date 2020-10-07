//
//  ChatRoomTableViewController.swift
//  FirebaseChat
//
//  Created by Rob Vance on 10/2/20.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {

    let modController = ChatRoomController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modController.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modController.chatRooms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        let chatRoom = modController.chatRooms[indexPath.row]
        cell.textLabel?.text = chatRoom.name

        return cell
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddChatRoomSegue" {
            guard let newChatRoomVC = segue.destination as? NewChatRoomViewController else { fatalError() }
            newChatRoomVC.modController = modController
        }
        if let chatRoomVC = segue.destination as? ChatRoomViewController {
            guard let selectedIndex = tableView.indexPathForSelectedRow?.row else { fatalError() }
            chatRoomVC.chatRoom = modController.chatRooms[selectedIndex]
            chatRoomVC.modController = modController
        }
    }
}

extension ChatRoomTableViewController: ModelControllerDelegate {
    func chatRoomsUpdated() {
        tableView.reloadData()
    }
}
