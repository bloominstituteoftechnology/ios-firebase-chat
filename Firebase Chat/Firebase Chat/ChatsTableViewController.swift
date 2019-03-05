//
//  ChatsTableViewController.swift
//  Firebase Chat
//
//  Created by Nelson Gonzalez on 3/5/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class ChatsTableViewController: UITableViewController {
    
    let chatsController = ChatsController()
    
//    var chats: [Chats]?{
//        didSet {
//            tableView.reloadData()
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadPosts()
    }
    
    func loadPosts(){
        
        
        chatsController.observeChatRooms { (chats) in
            //if a post has no uid then discard it
            guard chats.uid != nil else {return}
            
            self.chatsController.chatrooms.sort(by: {(chat1, chat2) -> Bool in
                Int(truncating: chat1.timeStamp!) > Int(truncating: chats.timeStamp!)
            })
            
            self.tableView.reloadData()
            
            
        }
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatsController.chatrooms.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatsCell", for: indexPath)

        let chats = chatsController.chatrooms[indexPath.row].name
        
        cell.textLabel?.text = chats
        

        return cell
    }
   

   

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddChat" {
            let destinationVC = segue.destination as? AddChatViewController
            destinationVC?.chatsController = chatsController
        } else if segue.identifier == "toChatVC" {
            let destinationVC = segue.destination as? ChatsViewController
            destinationVC?.chatsController = chatsController
            guard let index = tableView.indexPathForSelectedRow else {return}
            let chats = chatsController.chatrooms[index.row]
            destinationVC?.chats = chats
        }
    }
   

}
