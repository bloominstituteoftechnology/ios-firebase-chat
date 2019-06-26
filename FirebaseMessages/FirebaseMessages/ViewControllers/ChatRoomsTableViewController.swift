//
//  ChatRoomsTableViewController.swift
//  FirebaseMessages
//
//  Created by Jonathan Ferrer on 6/25/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit
import MessageKit
class ChatRoomsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        chatRoomController.createChatRoom(name: "Jons room")
       chatRoomController.fetchChatRooms()
        alertWithTF()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)


    }



    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatRoomController.chatRooms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)

        let chatRoom = chatRoomController.chatRooms[indexPath.row]

        cell.textLabel?.text = chatRoom.name

        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMessages" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MessageViewController else { return }

            destinationVC.chatRoomController = chatRoomController
            destinationVC.chatRoom = chatRoomController.chatRooms[indexPath.row]
        }
    }

    func alertWithTF() {
        //Step : 1
        let alert = UIAlertController(title: "Welcome to Fenam's Chat", message: "Enter your display name", preferredStyle: UIAlertController.Style.alert)
        //Step : 2
        let save = UIAlertAction(title: "Enter", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                //Read TextFields text data
                guard let text = textField.text else { return }
                self.chatRoomController.currentUser = Sender(senderId: UUID().uuidString, displayName: text)


            } else {
                print("TF 1 is Empty...")
            }

        }

        //Step : 3
        //For first TF
        alert.addTextField { (textField) in
            textField.placeholder = "Display namesdafsd"
            textField.textColor = .red
        }

        //Step : 4
        alert.addAction(save)
        self.present(alert, animated:true, completion: nil)

    }
    let chatRoomController = ChatRoomController()
}
