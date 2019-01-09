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
        
        chatController.fetchUser { (user, error) in
            if let error = error {
                NSLog("error fetching \(error)")
                return
            }
            
            if user == nil {
                self.askUsername()
                
            }
            
            
        }
        chatController.fetchChats {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    
    private func askUsername()
    {
        var usernameTextField: UITextField?
        let alert = UIAlertController(title: "Set username", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Username"
            usernameTextField = textField
        }
        let submitAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.chatController.createUser(name: usernameTextField?.text ?? "Anonymous" , completion: { (error) in
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
    
    
    
    
    
    
    private func addChatRoomAlert() {
        let alert = UIAlertController(title: "Please add Chatroom", message: nil, preferredStyle: .alert)
        
        var titleTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Chatroom Name"
            
            titleTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { (_) in
            self.chatController.creatingChatRoom(name: titleTextField?.text ?? "Chat Room", completion: { (chatId, error) in
                if let error = error {
                    NSLog("error creating chatroom\(error)")
                }
                
                MessageController.createMessage(text: "Hi", chatId: chatId!, completion: {
                    
                })
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
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let chatDetailViewController = ChatDetailViewController()
        let chatRoom = chatController.chat[indexPath.row]
        chatDetailViewController.chat = chatRoom
        chatController.fetchUser { (user, error) in
            if let error = error {
                NSLog("error fetching user \(error)")
                return
            }
            chatDetailViewController.user = user
            
            var navigated = false
            MessageController.fetchMessages(for: chatRoom.id!) { (message) in
                chatDetailViewController.messages.append(message)
                chatDetailViewController.messages.sort(by: { (a, b) -> Bool in
                    return a.timestamp?.intValue ?? 0 < b.timestamp?.intValue ?? 0
                })
                chatDetailViewController.messagesCollectionView.reloadData()
                if !navigated {
                    self.navigationController?.pushViewController(chatDetailViewController, animated: true)
                    navigated = true
                }
                
            }
            
            
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
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

