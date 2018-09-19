//
//  ChatRoomsTableViewController.swift
//  Firebase Chat
//
//  Created by Linh Bouniol on 9/18/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

class ChatRoomsTableViewController: UITableViewController {

    var chatRoomController: ChatRoomController?
    
    @IBAction func createChatRoom(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        chatRoomController?.createChatRoom(name: text) { (error) in
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatRoomController = ChatRoomController()
        chatRoomController?.fetchChatRoomsFromFirebase(completion: { (error) in
            self.tableView.reloadData()
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomController?.chatRooms.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        let chatRoom = chatRoomController?.chatRooms[indexPath.row]
        cell.textLabel?.text = chatRoom?.name

        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? MessageDetailViewController {
            detailVC.chatRoomController = chatRoomController

            if segue.identifier == "ViewMessageDetail" {
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                detailVC.chatRoom = chatRoomController?.chatRooms[indexPath.row]
            }
        }
    }
}
