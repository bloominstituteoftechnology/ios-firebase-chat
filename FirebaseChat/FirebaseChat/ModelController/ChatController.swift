//
//  ChatController.swift
//  FirebaseChat
//
//  Created by Cora Jacobson on 10/3/20.
//

import Foundation
import Firebase
import FirebaseDatabase

class ChatController {
    
    var chatRooms: [ChatRoom] = []
    var currentUser: Sender?
    
    let ref = Database.database().reference()
    
    func createChatRoom(title: String) {
        let chatRoom = ChatRoom(title: title)
        let chatId = chatRoom.identifier
        ref.child(chatId).setValue(["identifier": chatId, "title": title])
        chatRooms.append(chatRoom)
    }
    
    func deleteChatRoom(chatRoom: ChatRoom) {
        let chatId = chatRoom.identifier
        ref.child(chatId).removeValue()
        if let index = chatRooms.firstIndex(of: chatRoom) {
            chatRooms.remove(at: index)
        }
    }
    
    func createMessage(chatRoom: ChatRoom, sender: Sender, text: String) {
        let chatId = chatRoom.identifier
        guard let index = chatRooms.firstIndex(of: chatRoom) else { return }
        let message = Message(text: text, sender: sender)
        let messageId = message.messageId
        do {
            let messageData = try JSONEncoder().encode(message)
            let dictionary = try JSONSerialization.jsonObject(with: messageData, options: []) as? NSDictionary
            ref.child("\(chatId)/messages/\(messageId)").setValue(dictionary)
            chatRooms[index].messages.append(message)
        } catch {
            NSLog("Error encoding message: \(error)")
        }
    }
    
    func deleteMessage(chatRoom: ChatRoom, message: Message) {
        let chatId = chatRoom.identifier
        let messageId = message.messageId
        ref.child(chatId).child("messages").child(messageId).removeValue()
        if let roomIndex = chatRooms.firstIndex(of: chatRoom),
           let index = chatRooms[roomIndex].messages.firstIndex(of: message) {
            chatRooms[roomIndex].messages.remove(at: index)
        }
    }
    
    func fetchEverything(completion: @escaping () -> Void) {
        fetchChatRooms { (rooms) in
            self.chatRooms = rooms
            for room in self.chatRooms {
                self.fetchMessages(chatRoom: room) { (messages) in
                    room.messages = messages
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion()
            }
        }
    }
    
    func fetchChatRooms(completion: @escaping ([ChatRoom]) -> Void) {
        var rooms: [ChatRoom] = []
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as? DataSnapshot
                let value = snap?.value as? NSDictionary
                if let title = value?["title"] as? String,
                   let identifier = value?["identifier"] as? String {
                    let room = ChatRoom(title: title, messages: [], identifier: identifier)
                    rooms.append(room)
                }
            }
            completion(rooms)
        }
    }
    
    func fetchMessages(chatRoom: ChatRoom, completion: @escaping ([Message]) -> Void) {
        let chatId = chatRoom.identifier
        var messages: [Message] = []
        
        ref.child(chatId).child("messages").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as? DataSnapshot
                if let value = snap?.value as? NSDictionary {
                    
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: [])
                        let message = try JSONDecoder().decode(Message.self, from: data)
                        messages.append(message)
                    } catch {
                        NSLog("Error decoding message: \(error)")
                    }
                }
            }
            completion(messages)
        }
    }
    
}
