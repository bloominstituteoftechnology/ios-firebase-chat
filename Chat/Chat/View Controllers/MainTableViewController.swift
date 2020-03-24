//
//  MainTableViewController.swift
//  Chat
//
//  Created by Nick Nguyen on 3/24/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    private let chatroomController = ChatroomController()
    private let reuseCell = "ChatroomCell"
    private var roomName : String?
    private var roomPurpose: String?
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
      
    }

    
    @IBAction func addChatroomTapped(_ sender: UIBarButtonItem) {
          showAlert()
    }
    
    
   private func showAlert() {
        let ac = UIAlertController(title: "Add Chat room to server", message:nil , preferredStyle:.alert )
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        ac.addTextField { (textfield) in
            textfield.placeholder = " Enter Chatroom name"
            self.roomName = textfield.text!
        }
        ac.addTextField { (textField) in
            textField.placeholder = "What do we chat about ?"
            self.roomPurpose = textField.text!
        }
     ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak ac] (_) in
        let roomName = ac?.textFields![0].text
        let roomPurpose = ac?.textFields![1].text
        self.chatroomController.createChatroom(with: roomName!.capitalized, roomPurpose: roomPurpose!.capitalized) {
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
            }
        }
        }))
        present(ac, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return chatroomController.chatrooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath)
        
        let chatroom = chatroomController.chatrooms[indexPath.row]
        
        cell.textLabel?.text = "Room Name: \(chatroom.name)"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        
        cell.detailTextLabel?.text = "Topic: \(chatroom.roomPurpose)"
        cell.detailTextLabel?.textColor = .gray
        
        
        cell.imageView?.image = UIImage(systemName: "message.circle.fill")
        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatroomSegue" {
             guard let indexPath = tableView.indexPathForSelectedRow,
                         let destinationVC = segue.destination as? MessageThreadDetailViewController else { return }
            
            destinationVC.chatroomController = chatroomController
            destinationVC.chatroom = chatroomController.chatrooms[indexPath.row]
        }
    }
    
    
}
