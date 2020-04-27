//
//  ChatsTableViewController.swift
//  FirebaseChat
//
//  Created by Sal B Amer on 4/27/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatsTableViewController: MessagesViewController {
    
    //  Variables
    var room: ChatRoom?
    var messageController: MessageController?
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messageController?.fetchChatRoom {
            guard let room = self.room, let index = self.messageController?.rooms.firstIndex(of: room) else { return }
            self.messages = self.messageController?.rooms[index].messages ?? []
            self.messagesCollectionView.reloadData()
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EnterChatMessageSegue" {
            guard let destinationVC = segue.destination as? ChatDetailViewController else { return }
            destinationVC.messageController = messageController
            destinationVC.room = room
        }
    }
 

}

extension ChatsTableViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let chatRoomController = messageController, let room = room else { return }
        let message = Message(text: text, displayName: "User", messageId: UUID().uuidString, sentDate: Date())
        print(message)
        self.messages.append(message)
        messageController?.addNewMessageinRoom(room, message: message) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
            }
        }
    }
}

extension ChatsTableViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return Sender(senderId: UUID().uuidString, displayName: "User")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let message = messages[indexPath.item]
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
