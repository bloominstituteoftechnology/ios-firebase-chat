//
//  ChatTableViewController.swift
//
//
//  Created by Yvette Zhukovsky on 1/8/19.
//

import UIKit

class ChatTableViewController: UITableViewController {
    
    
    let chatController = ChatController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatController.fetchChats {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    private func addChatRoomAlert() {
        let alert = UIAlertController(title: "Please add Chatroom", message: nil, preferredStyle: .alert)
        
        var titleTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Chatroom Name"
            
            titleTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { (_) in
            self.chatController.creatingChatRoom(name: titleTextField?.text ?? "Chat Room", completion: { (error) in
                if let error = error {
                    NSLog("error creating chatroom\(error)")
                }
                
            })
        }
        alert.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        addChatRoomAlert()
        
    }
    
    
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatController.chat.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let chat = chatController.chat[indexPath.row]
        
        cell.textLabel?.text = chat.name
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    
}

