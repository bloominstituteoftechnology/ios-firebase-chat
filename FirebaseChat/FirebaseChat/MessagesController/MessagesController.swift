//
//  MessagesController.swift
//  FirebaseChat
//
//  Created by Bradley Diroff on 4/21/20.
//  Copyright © 2020 Bradley Diroff. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseDatabase

class MessagesController {
    
    var ref: DatabaseReference!
    
    var chats: [Chats] = []

    init() {
        ref = Database.database().reference()
    }
    
    func createChat(_ name: String) {
        let chats = Chats(title: name)
        self.ref.child("chats").child(chats.identifier).setValue(chats.title) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }
    }
    
    func loadChats(completion: () -> ()) {
        ref.child("chats").observeSingleEvent(of: .value, with: { (snapshot) in
          
            guard let snaps = snapshot.value as? [String:String] else {
                print("FAILURE converting snapshot")
                return
            }
            
            let chatList = snaps.compactMap({ $0.value }) ?? []
            
            for chat in chatList {
                print(chat)
                let item = Chats(title: chat)
                self.chats.append(item)
            }
            
//          let value = snapshot.value as? NSDictionary
//          let username = value?["username"] as? String ?? ""
//          let user = User(username: username)

          }) { (error) in
            print(error.localizedDescription)
        }
        completion()
    }
    
}

