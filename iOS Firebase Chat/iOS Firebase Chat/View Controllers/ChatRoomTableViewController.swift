//
//  ChatRoomTableViewController.swift
//  iOS Firebase Chat
//
//  Created by Dillon McElhinney on 10/23/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatRoomTableViewController: UITableViewController {
    
    var ref: DatabaseReference!
    var chatrooms: [ChatRoom] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        ref.child("/chatrooms").observe(DataEventType.value) { (snapshot) in
            guard let snapshotDict = snapshot.value as? NSDictionary else { return }
            
            if let data = try? JSONSerialization.data(withJSONObject: snapshotDict, options: []),
                let tempChatrooms = try? JSONDecoder().decode([String: ChatRoom].self, from: data).map() { $0.value } {
                self.chatrooms = tempChatrooms
            }
        }
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
        let chatroom = chatrooms[indexPath.row]

        cell.textLabel?.text = chatroom.title
        
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
