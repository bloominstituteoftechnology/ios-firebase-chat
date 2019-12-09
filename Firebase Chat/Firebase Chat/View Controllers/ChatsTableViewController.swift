//
//  ChatsTableViewController.swift
//  Firebase Chat
//
//  Created by Vici Shaweddy on 12/4/19.
//  Copyright © 2019 Vici Shaweddy. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatsTableViewController: UITableViewController {
    let chatController = ChatModelController()
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadChats()
    }
    
    private func loadChats() {
        self.chatController.ref.child("messages").observe(.value) { snapshot in
            var chats = [Chat]()
            for chat in snapshot.children {
                if let chat = chat as? DataSnapshot {
                    if let chatDictionary = chat.value as? [String: AnyObject] {
                        let chat = Chat(dictionary: chatDictionary)
                        chats.append(chat)
                    }
                }
            }
            self.chats = chats
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)

        // Configure the cell...
        let chat = self.chats[indexPath.row]
        cell.textLabel?.text = chat.messages.last?.message
    
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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



    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? ChatRoomViewController else {
            return
        }
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let chat = self.chats[indexPath.row]
            detailVC.chat = chat
        }
        
        detailVC.chatController = self.chatController
    }


}
