//
//  ChatRoomTableViewController.swift
//  FirebaseChat
//
//  Created by Lambda_School_Loaner_204 on 12/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {

    let chatRoomController = ChatRoomController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatRoomController.fetchChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func createChatRoomAlert() {
        let alert = UIAlertController(title: "Create a new chat room", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter chat room title:"
        }
        
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
            if let title = alert.textFields?.first?.text,
                !title.isEmpty {
                self.chatRoomController.createChatRoom(with: title) {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func createChatRoom(_ sender: UIBarButtonItem) {
        createChatRoomAlert()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomController.chatRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = chatRoomController.chatRooms[indexPath.row].title
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChatRoomDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ChatRoomDetailViewController else { return }
            
            destinationVC.chatRoomController = chatRoomController
            destinationVC.chatRoom = chatRoomController.chatRooms[indexPath.row]
        }
    }


}
