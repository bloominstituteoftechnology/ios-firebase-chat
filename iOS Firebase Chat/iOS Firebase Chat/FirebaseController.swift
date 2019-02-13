//
//  FirebaseController.swift
//  iOS Firebase Chat
//
//  Created by Dillon McElhinney on 10/23/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import FirebaseDatabase
import MessageKit

class FirebaseContoller {
    
    // MARK: - Properties
    private let ref: DatabaseReference!
    var chatrooms: [Chatroom] = []
    var messages: [Message] = []
    
    var currentSender = Sender(id: "38FF26EF-367C-4D42-A5DD-642351425215", displayName: "Dillon")
    
    private var observeChatroomsHandle: UInt? = nil
    private var observeMessagesHandle: UInt? = nil
    
    // MARK: - Initializers
    init() {
        ref = Database.database().reference()
    }
    
    // MARK: - Chatroom Methods
    func loadChatrooms(completion: @escaping CompletionHandler = { _ in }) {
        observeChatroomsHandle = ref.child("/chatrooms").observe(DataEventType.value) { (snapshot) in
            guard let snapshotDict = snapshot.value as? NSDictionary else { return }
            
            if let data = try? JSONSerialization.data(withJSONObject: snapshotDict, options: []),
                let tempChatrooms = try? JSONDecoder().decode([String: Chatroom].self, from: data).map() { $0.value } {
                // Order chatrooms in descending order, so the most recent is at the top
                self.chatrooms = tempChatrooms.sorted() { $0.timestampUpdated > $1.timestampUpdated }
                completion(nil)
            }
        }
    }
    
    func closeChatrooms() {
        if let observeChatroomsHandle = observeChatroomsHandle {
            ref.removeObserver(withHandle: observeChatroomsHandle)
            self.observeChatroomsHandle = nil
        }
    }
    
    func makeNewChatRoom(with title: String) {
        let identifier = UUID().uuidString
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let chatroom = [
            "title": title,
            "identifier": identifier,
            "timestampUpdated": timestamp
        ]
        
        ref.child("/chatrooms/\(identifier)").setValue(chatroom)
    }
    
    func deleteChatroom(with indexPath: IndexPath) {
        let chatroom = chatrooms[indexPath.row]
        ref.child("/chatrooms/\(chatroom.identifier)").removeValue()
    }
    
    // MARK: - Message Methods
    func loadMessages(for chatroom: Chatroom, completion: @escaping CompletionHandler = { _ in }) {
        observeMessagesHandle = ref.child("/messages/\(chatroom.identifier)").observe(DataEventType.value) { (snapshot) in
            guard let snapshotDict = snapshot.value as? NSDictionary else { return }
            
            if let data = try? JSONSerialization.data(withJSONObject: snapshotDict, options: []) {
                do {
                    let tempMessages = try JSONDecoder().decode([String: Message].self, from: data).map() { $0.value }
                    // Order messages in ascending order so the most recent is at the bottom.
                    self.messages = tempMessages.sorted() { $0.timestamp < $1.timestamp }
                    completion(nil)
                } catch {
                    NSLog("Error decoding messages: \(error)")
                }
            }
        }
    }
    
    func addMessage(to chatroom: Chatroom, with text: String, sender: Sender) {
        let identifier = UUID().uuidString
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let sender = [
            "displayName": sender.displayName,
            "id": sender.id
        ]
        let message: [String: Any] = [
            "text": text,
            "identifier": identifier,
            "timestamp": timestamp,
            "sender": sender
        ]
        
        ref.child("/messages/\(chatroom.identifier)/\(identifier)").setValue(message)
        ref.child("/chatrooms/\(chatroom.identifier)/timestampUpdated").setValue(timestamp)
    }
    
    func closeMessages() {
        if let observeMessagesHandle = observeMessagesHandle {
            ref.removeObserver(withHandle: observeMessagesHandle)
            self.observeMessagesHandle = nil
            messages = []
        }
    }
}
