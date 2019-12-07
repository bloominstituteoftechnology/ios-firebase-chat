//
//  ChatRoomsTableViewController.swift
//  FirebaseChat
//
//  Created by John Kouris on 12/7/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//

import UIKit

class ChatRoomsTableViewController: UITableViewController {

    @IBOutlet weak var createChatRoomTextField: UITextField!
    let chatController = ChatRoomController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatController.getChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func createChatRoom(_ sender: Any) {
        createChatRoomTextField.resignFirstResponder()
        chatController.createChatRoom(with: createChatRoomTextField.text!)
        createChatRoomTextField.text = ""
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatController.chatRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        
        cell.textLabel?.text = chatController.chatRooms[indexPath.row].title
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
