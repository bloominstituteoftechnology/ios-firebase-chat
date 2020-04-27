//
//  ChatRoomTableViewController.swift
//  FirebaseChat
//
//  Created by Jessie Ann Griffin on 4/24/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {

     // MARK: - Properties
    
    let chatRoomController = ChatRoomController()
    
    @IBOutlet weak var chatRoomTitleTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatRoomController.fetchChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func createNewChatRoom(_ sender: UITextField) {
        chatRoomTitleTextField.resignFirstResponder()
        
        guard let chatRoomTitle = chatRoomTitleTextField.text else { return }
        
        chatRoomTitleTextField.text = ""
        
        chatRoomController.createChatRoom(with: chatRoomTitle) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomController.chatRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        
        cell.textLabel?.text = chatRoomController.chatRooms[indexPath.row].title
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewChatRoom" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MessageViewController else { return }
            
            destinationVC.chatRoomController = chatRoomController
            destinationVC.chatRoom = chatRoomController.chatRooms[indexPath.section]
        }
    }
}
