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
        
        if let currentUserData = UserDefaults.standard.data(forKey: "currentUser") {
            
            let plistDecoder = PropertyListDecoder()
            
            do {
                modelController.currentUser = try plistDecoder.decode(Sender.self, from: currentUserData)
            } catch{
                NSLog("Error decoding Sender: \(error)")
            }
            
        } else {
            presentUserNameSubmissionAlert()
        }
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
    
    private func presentUserNameSubmissionAlert() {
        
        let ac = UIAlertController(title: "Enter a username", message: "This will be your user name while using this app.", preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Username"
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            guard let username = ac.textFields?.first?.text else { return }
            
            let sender = Sender(displayName: username, senderId: UUID().uuidString)
            
            let plistEncoder = PropertyListEncoder()
            
            do {
                let data = try plistEncoder.encode(sender)
                
                UserDefaults.standard.set(data, forKey: "currentUser")
            } catch{
                NSLog("Error encoding sender: \(error)")
            }
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true, completion: nil)
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
