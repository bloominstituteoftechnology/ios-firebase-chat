//
//  ChatTableViewController.swift
//  FirebaseChat
//
//  Created by Sal B Amer on 4/24/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController {
    
    let messageController = MessageController()
    
    //IBOUTLETS
    @IBOutlet weak var chatRoomTitle: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        
        cell.textLabel?.text = messageController.chatThreads[indexPath.row].title
        return cell
    }




    // IBActions - search bar input to create chat
    
    @IBAction func pullToRefresh(_ sender: Any) {
        // once fetch code is setup
    }
    
    @IBAction func createANewChatroom(_ sender: Any) {
                
        chatRoomTitle.resignFirstResponder()

        guard let chatroomTitle = chatRoomTitle.text else { return }
        chatRoomTitle.text = ""

        messageController.createChatroom(with:chatroomTitle) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }


    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
