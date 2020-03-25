//
//  ChatRoomTableViewController.swift
//  FirebaseChat
//
//  Created by Lambda_School_Loaner_268 on 3/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {
    
    let roomController = RoomController()
    let messageController = MessageController()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        roomController.fetchChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    private func makeNewRoom() {
        
        let alert = UIAlertController(title: "Make new room?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
        alert.addTextField { (textField) in
            textField.placeholder = "Enter room title: "
        }
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
            if let roomName = alert.textFields?.first?.text, !roomName.isEmpty {
                self.roomController.createChatRoom(with: roomName) {
                        
                        self.tableView.reloadData()
                        }
            }
        }))
        self.present(alert, animated: true)
        
    }
    
    
    @IBAction func newRoom(_ sender: Any) {
        makeNewRoom()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return roomController.chatRooms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = roomController.chatRooms[indexPath.row].roomName

        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "oneSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ChatRoomDetailViewController else { return }
            destinationVC.roomController = roomController
            destinationVC.room = roomController.chatRooms[indexPath.row]
            destinationVC.messageController = self.messageController
        }
    }
    

}
