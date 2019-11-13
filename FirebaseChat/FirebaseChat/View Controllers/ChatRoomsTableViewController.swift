//
//  ChatRoomsTableViewController.swift
//  FirebaseChat
//
//  Created by Gi Pyo Kim on 11/12/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import UIKit

class ChatRoomsTableViewController: UITableViewController {
    @IBOutlet weak var chatRoomTextField: UITextField!
    
    let chatRoomController = ChatRoomController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUserDictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String: String] {
            let currentUser = Sender(dictionary: currentUserDictionary)
            chatRoomController.currentUser = currentUser
        } else {
            let alert = UIAlertController(title: "Set a username", message: nil, preferredStyle: .alert)
            
            var usernameTextField: UITextField!
            
            alert.addTextField { (textField) in
                textField.placeholder = "Username:"
                usernameTextField = textField
            }
            
            let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
                let displayName = usernameTextField.text ?? "Unknown user"
                let id = UUID().uuidString
                
                let sender = Sender(senderId: id, displayName: displayName)
                
                UserDefaults.standard.set(sender.dictionaryRepresentation, forKey: "currentUser")
                
                self.chatRoomController.currentUser = sender
            }
            
            alert.addAction(submitAction)
            present(alert, animated: true, completion: nil)
            
        }
        
        chatRoomController.fetchChatRooms() {
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func createNewChatRoom(_ sender: Any) {
        chatRoomTextField.resignFirstResponder()
        
        guard let chatRoomTitle = chatRoomTextField.text else { return }
        
        chatRoomTextField.text = ""
        
        chatRoomController.createChatRoom(title: chatRoomTitle) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
