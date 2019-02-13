//
//  ModelController.swift
//  ios-firebase-chat
//
//  Created by Benjamin Hakes on 2/12/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseCore

class ModelController {
    
    func createThreadOnFirebase(thread: Thread, on ref: DatabaseReference){
        
        let array = ["title": thread.title, "threadID": thread.threadID]
        ref.child("\(thread.threadID)").setValue(array)
        
    }
    
    func fetchThreadsFromFirebase(on ref: DatabaseReference, completion: @escaping () -> Void) -> [Thread]{
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            guard let snapshotDict = snapshot.value as? NSDictionary else { return }
            
            if let data = try? JSONSerialization.data(withJSONObject: snapshotDict, options: []),
                let tempThreads = try? JSONDecoder().decode([String: Thread].self, from: data).map() { $0.value } {
                return tempThreads
            }
        
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func createMessageInThreadOnFirebase(thread: Thread, message: Message, on ref: DatabaseReference){
        ref.child("\(thread.threadID)").child("\(message.messageID)").setValue(message)
    }
    
    func fetchMessagesInThreadFromFirebase(){
        
    }
    
    
    // MARK: - Properties
}
