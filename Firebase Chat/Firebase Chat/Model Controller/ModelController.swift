
import Foundation
import MessageKit

/*
 
 1. Create a chat room in Firebase
 2. Fetch chat rooms from Firebase
 3. Create a message in a chat room in Firebase
 4. Fetch messages in a chat room from Firebase
 
 */

class ModelController {
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        
        let chatRoom = ChatRoom(title: title)
        
        let requestURL = ModelController.baseURL.appendingPathComponent(chatRoom.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(chatRoom)
        } catch {
            NSLog("Error encoding thread to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with message thread creation data task: \(error)")
                completion()
                return
            }
            
            self.chatRooms.append(chatRoom)
            completion()
            
        }.resume()
        
    }
    
    func fetchChatRooms(completion: @escaping () -> Void) {
        
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, sender: String, completion: @escaping () -> Void) {
        
    }
    
    func fetchMessage(from chatRoom: ChatRoom, completion: @escaping () -> Void) {
        
    }
    
    static let baseURL = URL(string: "https://fir-chat-b24c0.firebaseio.com/")!
    var chatRooms: [ChatRoom] = []
    var currentUser: Sender?
    
}
