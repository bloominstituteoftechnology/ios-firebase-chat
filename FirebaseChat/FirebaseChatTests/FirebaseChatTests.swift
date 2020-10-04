//
//  FirebaseChatTests.swift
//  FirebaseChatTests
//
//  Created by Cora Jacobson on 10/3/20.
//

import XCTest
import Firebase
import FirebaseDatabase

@testable import FirebaseChat

class FirebaseChatTests: XCTestCase {
        
    func testCreateChatRoom() {
        let chatController = ChatController()
        let title = "Test One"
        chatController.createChatRoom(title: title)
        XCTAssertEqual(chatController.chatRooms.count, 1)
    }
    
    func testCreatedChatRoomWasAddedToFirebase() {
        let chatController = ChatController()
        let title = "Test Two"
        var fetchedTitle = ""
        let resultsExpectation = expectation(description: "Wait for results")
        
        chatController.createChatRoom(title: title)
        let identifier = chatController.chatRooms[0].identifier
        chatController.ref.child(identifier).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let fetchTitle = value?["title"] as? String {
                fetchedTitle = fetchTitle
                resultsExpectation.fulfill()
            }
        })
        wait(for: [resultsExpectation], timeout: 1)
        XCTAssertEqual(fetchedTitle, title)
    }
    
    func testDeleteChatRoom_ShouldRemoveFromServerAndLocalArray() {
        let chatController = ChatController()
        let title = "Test Deleting ChatRoom"
        chatController.createChatRoom(title: title)
        
        XCTAssertEqual(chatController.chatRooms.count, 1)
        
        let resultsExpectation = expectation(description: "Wait for results")
        
        let chatRoom = chatController.chatRooms[0]
        let identifier = chatRoom.identifier
        var results: NSDictionary?
        
        chatController.deleteChatRoom(chatRoom: chatRoom)
        
        chatController.ref.child(identifier).observeSingleEvent(of: .value, with: { (snapshot) in
            results = snapshot.value as? NSDictionary
            resultsExpectation.fulfill()
        })
        
        wait(for: [resultsExpectation], timeout: 1)
        XCTAssertNil(results)
        XCTAssertNil(chatController.chatRooms.firstIndex(of: chatRoom))
        XCTAssertEqual(chatController.chatRooms.count, 0)
    }
    
    func testCreateMessage_ShouldAddToServerAndLocalArray() {
        let chatController = ChatController()
        let title = "Test Three - with Message"
        chatController.createChatRoom(title: title)
        
        let chatRoom = chatController.chatRooms[0]
        let sender = Sender(displayName: "Cora")
        let text = "Testing..."
        
        let resultsExpectation = expectation(description: "Wait for results")
        let identifier = chatRoom.identifier
        var resultText = ""
        
        chatController.createMessage(chatRoom: chatRoom, sender: sender, text: text)
        
        XCTAssertEqual(text, chatRoom.messages[0].text)
        
        let messageId = chatRoom.messages[0].messageId
        
        chatController.ref.child(identifier).child("messages").child(messageId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                resultText = value["text"] as? String ?? ""
                resultsExpectation.fulfill()
            }
        })
        
        wait(for: [resultsExpectation], timeout: 1)
        XCTAssertEqual(text, resultText)
    }
    
    func testDeleteMessage_ShouldRemoveFromServerAndLocalArray() {
        let chatController = ChatController()
        let title = "Test Four - Deleted Message"
        chatController.createChatRoom(title: title)
        
        let chatRoom = chatController.chatRooms[0]
        let sender = Sender(displayName: "Cora")
        let text = "Testing..."
        
        let setUpExpectation = expectation(description: "Wait for set up")
        let identifier = chatRoom.identifier
        var resultText = ""
        
        chatController.createMessage(chatRoom: chatRoom, sender: sender, text: text)
        
        XCTAssertEqual(chatRoom.messages.count, 1)
        XCTAssertEqual(text, chatRoom.messages[0].text)
        
        let message = chatRoom.messages[0]
        let messageId = message.messageId
        
        chatController.ref.child(identifier).child("messages").child(messageId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                resultText = value["text"] as? String ?? ""
                setUpExpectation.fulfill()
            }
        })
        
        wait(for: [setUpExpectation], timeout: 1)
        XCTAssertEqual(text, resultText)
        
        let resultsExpectation = expectation(description: "Wait for results")
        var value: NSDictionary?
        
        chatController.deleteMessage(chatRoom: chatRoom, message: message)
        
        chatController.ref.child(identifier).child("messages").child(messageId).observeSingleEvent(of: .value, with: { (snapshot) in
            value = snapshot.value as? NSDictionary
            resultsExpectation.fulfill()
        })
        
        wait(for: [resultsExpectation], timeout: 1)
        XCTAssertEqual(chatRoom.messages.count, 0)
        XCTAssertNil(value)
    }
    
    func testFetchChatRooms_ShouldReturnChatRooms() {
        let chatController = ChatController()
        let resultsExpectation = expectation(description: "Wait for results")
        
        XCTAssertEqual(chatController.chatRooms.count, 0)
        
        chatController.fetchChatRooms { (rooms) in
            chatController.chatRooms = rooms
            resultsExpectation.fulfill()
        }
        
        wait(for: [resultsExpectation], timeout: 2)

        XCTAssertNotEqual(chatController.chatRooms.count, 0)
    }
    
    func testFetchMessages_ShouldReturnTestMessageText() {
        let chatController = ChatController()
        let resultsExpectation = expectation(description: "Wait for results")

        chatController.fetchChatRooms { (rooms) in
            chatController.chatRooms = rooms
            resultsExpectation.fulfill()
        }

        let testRoomId = "E6DB4CB4-F5DE-417C-96C0-541235BE42FE"
        let testMessage = "Testing..."

        wait(for: [resultsExpectation], timeout: 2)
        let testRoomIndex = chatController.chatRooms.firstIndex(where: { $0.identifier == testRoomId }) ?? 100
        XCTAssertNotEqual(chatController.chatRooms.count, 0)
        XCTAssertNotEqual(testRoomIndex, 100)

        let messageExpectation = expectation(description: "Wait for messages")

        chatController.fetchMessages(chatRoom: chatController.chatRooms[testRoomIndex]) { (messages) in
            chatController.chatRooms[testRoomIndex].messages = messages
            messageExpectation.fulfill()
        }

        wait(for: [messageExpectation], timeout: 2)
        XCTAssertEqual(chatController.chatRooms[testRoomIndex].messages.count, 1)

        let testRoomMessage = chatController.chatRooms[testRoomIndex].messages[0].text

        XCTAssertEqual(testMessage, testRoomMessage)
    }
    
    func testFetchEverything_ShouldReturnChatRoomsAndMessages() {
        let chatController = ChatController()
        let resultsExpectation = expectation(description: "Wait for results")
        
        chatController.fetchEverything {
            resultsExpectation.fulfill()
        }
        
        wait(for: [resultsExpectation], timeout: 2)
        XCTAssertNotEqual(chatController.chatRooms.count, 0)
        
        let testRoomId = "E6DB4CB4-F5DE-417C-96C0-541235BE42FE"
        let testRoomIndex = chatController.chatRooms.firstIndex(where: { $0.identifier == testRoomId }) ?? 100
        XCTAssertNotEqual(testRoomIndex, 100)
        XCTAssertEqual(chatController.chatRooms[testRoomIndex].messages.count, 1)
    }

}
