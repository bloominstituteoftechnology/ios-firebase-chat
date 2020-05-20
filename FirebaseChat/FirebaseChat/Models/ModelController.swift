////
////  ModelController.swift
////  FirebaseChat
////
////  Created by Shawn James on 5/19/20.
////  Copyright © 2020 Shawn James. All rights reserved.
////
//
//import Foundation
//import FirebaseDatabase
//
//class ModelController {
//
//    // MARK: - Properties
//    private let databaseReference = Database.database().reference()
//    var conversationReferences = [DatabaseReference]()
////    var currentUser: Sender? {
////        didSet { UserDefaults.standard.set(currentUser?.dictionaryRepresentation, forKey: "currentUser") }
////    }
//
//    init() {
//        if let currentUserDictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String : String], let currentUser = Sender(dictionary: currentUserDictionary) {
//            self.currentUser = currentUser
//        }
//    }
//
//    // MARK: - Methods
////    Create a chat room in Firebase
//    func addNewConversation(named name: String) {
//        databaseReference.child("Conversations").childByAutoId().setValue((["name" : name])) { (error, conversationReference) in
//            self.conversationReferences.append(conversationReference)
//        }
//    }
//
////    Fetch chat rooms from Firebase
//    func fetchConversationsFromFirebase() {
//        databaseReference.child("Conversations").observe(.value) { (dataSnapshot) in
//            dataSnapshot.
//        }
//    }
//
////    Create a message in a chat room in Firebase
//    func addNewMessage() {
//
//    }
//
////    Fetch messages in a chat room from Firebase
//    func fetchMessagesFromFirebase() {
//
//    }
//
//}
