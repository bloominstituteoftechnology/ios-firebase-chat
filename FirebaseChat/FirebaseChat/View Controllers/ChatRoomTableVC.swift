//
//  ChatRoomTableVC.swift
//  FirebaseChat
//
//  Created by Chad Parker on 2020-06-09.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import UIKit

class ChatRoomTableVC: UITableViewController {
   
   let modelController = ModelController()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      modelController.delegate = self
   }
   
   // MARK: - Table view data source
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return modelController.chatRooms.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
      
      let chatRoom = modelController.chatRooms[indexPath.row]
      cell.textLabel?.text = chatRoom.name
      
      return cell
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let messageVC = segue.destination as? MessageVC {
         guard let selectedIndex = tableView.indexPathForSelectedRow?.row else { fatalError() }
         messageVC.chatRoom = modelController.chatRooms[selectedIndex]
      }
      if segue.identifier == "CreateChatRoomSegue" {
         guard let newChatRoomVC = segue.destination as? NewChatRoomVC else { fatalError() }
         newChatRoomVC.modelController = modelController
      }
   }
}

extension ChatRoomTableVC: ModelControllerDelegate {
   func chatRoomsWereUpdated() {
      
   }
   
   
}
