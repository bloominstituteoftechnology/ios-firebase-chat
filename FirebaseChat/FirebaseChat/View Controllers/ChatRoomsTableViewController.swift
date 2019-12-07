//
//  ChatRoomsTableViewController.swift
//  FirebaseChat
//
//  Created by John Kouris on 12/7/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit

class ChatRoomsTableViewController: UITableViewController {

    @IBOutlet weak var createChatRoomTextField: UITextField!
    let chatController = ChatRoomController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatController.getChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func createChatRoom(_ sender: Any) {
        createChatRoomTextField.resignFirstResponder()
        chatController.createChatRoom(with: createChatRoomTextField.text!)
        createChatRoomTextField.text = ""
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatController.chatRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        
        cell.textLabel?.text = chatController.chatRooms[indexPath.row].title
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewMessageThread" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MessageViewController else { return }
            destinationVC.chatController = chatController
            destinationVC.chatRoom = chatController.chatRooms[indexPath.row]
        }
    }

}
