//
//  ChatRoomTableViewController.swift
//  FirebaseChat
//
//  Created by Christopher Aronson on 6/18/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {

    var modelController = ModelController()
    
    @IBOutlet var chatRoomNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        modelController.fetchChatRooms { (error) in
            
            if let error = error {
                NSLog("\(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.chatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        cell.textLabel?.text = modelController.chatRooms[indexPath.row].chatRoomName

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMessages" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
               
                let destination = segue.destination as! MessageViewController
                let currentCell = tableView.cellForRow(at: indexPath)
                destination.chatRoomName = currentCell?.textLabel?.text
                destination.modelController = modelController
            }
        }
    }

    @IBAction func creatChatRoomButtonTapped(_ sender: Any) {
        
        chatRoomNameTextField.resignFirstResponder()
        
        guard let chatRoomName = chatRoomNameTextField.text else { return }
        
        chatRoomNameTextField.text = ""
        
        modelController.createChatRoom(with: chatRoomName) { error in
            
            if let error = error {
                NSLog("Issue creating Chatroom on Server: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
}
