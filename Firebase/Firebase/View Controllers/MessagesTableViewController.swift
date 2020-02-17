//
//  MessagesTableViewController.swift
//  Firebase
//
//  Created by Alex Thompson on 2/16/20.
//  Copyright © 2020 Lambda_School_Loaner_213. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MessagesTableViewController: UITableViewController {
    let chatController = ModelController()
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chats.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        
        let chat = self.chats[indexPath.row]
        cell.textLabel?.text = chat.messages.last?.message
        
        return cell
    }


    
    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? ChatViewController else {
            return
        }
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let chat = self.chats[indexPath.row]
            detailVC.chat = chat
        }
        
        detailVC.chatController = self.chatController
    }
}
