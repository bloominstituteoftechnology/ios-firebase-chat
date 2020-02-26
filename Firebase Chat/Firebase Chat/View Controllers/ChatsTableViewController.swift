//
//  ChatsTableViewController.swift
//  Firebase Chat
//
//  Created by Michael on 2/25/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit

class ChatsTableViewController: UITableViewController {

    let chatRoomController = ChatRoomController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatRoomController.fetchChatRoomsCodable {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addChatRoomTapped(_ sender: Any) {
        let alert = UIAlertController(title: "New Chat Room", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Chat Room Name:"
        })

        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in

            if let name = alert.textFields?.first?.text {
                self.chatRoomController.createChatRoomCodable(with: name)
            }
            
            self.tableView.reloadData()
        }))

        self.present(alert, animated: true)
    }
    
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatRoomController.chatRooms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        let chatRoom = chatRoomController.chatRooms[indexPath.row]
        cell.textLabel?.text = chatRoom.title

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let chatRoom = chatRoomController.chatRooms[indexPath.row]
            chatRoomController.deleteChatRoom(chatRoom: chatRoom)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatRoomDetailSegue" {
            guard let chatDetailVC = segue.destination as? ChatDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            
            chatDetailVC.chatRoomController = chatRoomController
            let chatRoom = chatRoomController.chatRooms[indexPath.row]
            chatDetailVC.chatRoom = chatRoom
        }
    }
}

