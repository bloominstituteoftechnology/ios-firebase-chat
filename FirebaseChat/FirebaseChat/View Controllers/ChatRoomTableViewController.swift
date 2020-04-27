//
//  ChatRoomTableViewController.swift
//  FirebaseChat
//
//  Created by Joshua Rutkowski on 4/26/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {

    // MARK: - Variables
    let chatController = ChatController()

      
      // MARK: - View Lifecycle
      override func viewDidLoad() {
          super.viewDidLoad()
        // Adds bar button to add a new chat room
          navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRoom))
          chatController.fetchRooms {
              self.tableView.reloadData()
          }
      }
      
    // Creates a new chatroom
      @objc private func addRoom() {
          let alert = UIAlertController(title: "Create a new chatroom", message: "Enter the room name and hit OK", preferredStyle: .alert)
          alert.addTextField()
          alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let textField = alert.textFields?.first, let name = textField.text, !name.isEmpty else { return }
              self.chatController.addRoom(with: name) {
                  self.chatController.fetchRooms {
                      self.dismiss(animated: true)
                      self.tableView.reloadData()
                  }
              }
          })
          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
          self.present(alert, animated: true)
      }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatController.rooms.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        let room = chatController.rooms[indexPath.row]
        cell.textLabel?.text = room.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let room = chatController.rooms[indexPath.row]
            chatController.deleteRoom(room) {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowMessageSegue":
            guard let destinationVC = segue.destination as? MessageDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let room = chatController.rooms[indexPath.row]
            destinationVC.chatController = chatController
            destinationVC.room = room
        default:
            break
        }
    }

}
