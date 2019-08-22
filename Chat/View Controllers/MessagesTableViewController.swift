//
//  MessagesTableViewController.swift
//  Chat
//
//  Created by Kat Milton on 8/20/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewController: UITableViewController {
    
    @IBOutlet weak var chatRoomTitleTextField: UITextField!

    let firebaseController = FirebaseController()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        loadChatRooms()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let currentSender = UserDefaults.standard.currentSender {
            firebaseController.currentUser = currentSender
        } else {
            let alert = UIAlertController(title: "Set a username", message: nil, preferredStyle: .alert)
            
            var usernameTextField: UITextField!
            
            alert.addTextField { (textField) in
                textField.placeholder = "Username:"
                usernameTextField = textField
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
                
                let displayName = usernameTextField.text ?? "No name"
                let id = UUID().uuidString
                
                let sender = Sender(displayName: displayName, senderId: id)
                
                UserDefaults.standard.currentSender = sender
                
                self.firebaseController.currentUser = sender
            }
            
            alert.addAction(submitAction)
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func loadChatRooms(){
        
        firebaseController.observeChatRooms { (chatrooms) in
            guard chatrooms.senderId != nil else {return}
            
            self.firebaseController.chatRooms.sort(by: {(chat1, chat2) -> Bool in
                Int(truncating: chat1.timeStamp!) > Int(truncating: chatrooms.timeStamp!)
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func createThread(_ sender: Any) {
        chatRoomTitleTextField.resignFirstResponder()
        
        guard let roomTitle = chatRoomTitleTextField.text else { return }
        
        
        firebaseController.uploadDataToServer(chatRoomName: roomTitle) {
            self.chatRoomTitleTextField.text = ""
            
        }
        
//        firebaseController.createChatRoom(with: roomTitle) {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseController.chatRooms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        
        cell.textLabel?.text = firebaseController.chatRooms[indexPath.row].name
        
        return cell
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewMessageThread" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ChatRoomViewController else { return }
            
            destinationVC.firebaseController = firebaseController
            destinationVC.chatRoom = firebaseController.chatRooms[indexPath.row]
        }
    }
    

}
