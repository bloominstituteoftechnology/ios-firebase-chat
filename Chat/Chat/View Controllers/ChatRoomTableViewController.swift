//
//  ChatRoomTableViewController.swift
//  Chat
//
//  Created by Chris Dobek on 5/20/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatRoomTableViewController: UITableViewController {
    
    let databaseReference = Database.database().reference()
    var chatRooms = [String]()
    var chatRoomReference = [DatabaseReference]()
    @IBOutlet var chatRoomTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        fetchNewChatRoom()
    }
    
    @IBAction func createChatRoom(_ sender: Any){
        chatRoomTitleTextField.resignFirstResponder()
        
        guard let chatRoomTitle = chatRoomTitleTextField.text, !chatRoomTitle.isEmpty else { return }
        databaseReference.child("Chat Rooms").childByAutoId().setValue((["title" : title]))
        chatRoomTitleTextField.text = " "
    }
    
    func fetchNewChatRoom() {
        databaseReference.child("Chat Room").observe(.childAdded) { (dataSnapshot) in
            guard let title = dataSnapshot.childSnapshot(forPath: "title").value as? String else { return }
            self.chatRoomReference.append(dataSnapshot.ref)
            self.chatRooms.append(title)
            self.tableView.reloadData()
        }
    }
    
    func createSenderIdIfNeeded() {
        guard UserDefaults.standard.string(forKey: "senderId") == nil else { return }

        // Present alert to input & save username
        let alert = UIAlertController(title: "Set Your Username", message: nil, preferredStyle: .alert)
        var usernameTextField: UITextField!
        alert.addTextField { (textField) in
            usernameTextField = textField
            textField.placeholder = "Username:"
        }
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            let displayName = usernameTextField.text ?? "No Name"
            let id = UUID().uuidString
            UserDefaults.standard.set(id, forKey: "senderId")
            UserDefaults.standard.set(displayName, forKey: "displayName")
        }))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return chatRooms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageThreadCell", for: indexPath)
        cell.textLabel?.text = chatRooms[indexPath.row]
        return cell
    }
   
    // MARK: - Navigation

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ViewMessageThread", let indexPath = tableView.indexPathForSelectedRow else { return }
        let messageViewController = segue.destination as! MessageViewController
        messageViewController.chatRoom = chatRooms[indexPath.row]
        messageViewController.chatRoomReference = chatRoomReference[indexPath.row]
    }
   

}
