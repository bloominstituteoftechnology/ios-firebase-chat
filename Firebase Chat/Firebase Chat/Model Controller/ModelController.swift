
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
        
        let requestURL = ModelController.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching chat rooms: \(error)")
                completion()
                return
            }
            
            guard let data = data else { NSLog("No data returned from data task"); completion(); return }
            
            do {
                self.chatRooms = try JSONDecoder().decode([String: ChatRoom].self, from: data).map({ $0.value })
            } catch let jsonError as DecodingError {
                let ctx: DecodingError.Context
                switch jsonError {
                    
                case .typeMismatch(let type, let context):
                    print("Mismatched type: \(type)")
                    ctx = context
                case .valueNotFound(let type, let context):
                    print("Missing value of type \(type)")
                    ctx = context
                case .keyNotFound(let key, let context):
                    print("Unknown key: \(key.stringValue)")
                    ctx = context
                case .dataCorrupted(let context):
                    print("Corrupted data")
                    ctx = context
                }
                
                let path = ctx.codingPath.map { p -> String in
                    return p.intValue != nil ? "[\(p.intValue!)]" : "."+p.stringValue
                    }.joined()
                
                print("path: [root]\(path)")
                
                
                self.chatRooms = []
                NSLog("Error decoding chat rooms from JSON data: \(error)")
            } catch {
                self.chatRooms = []
                NSLog("Unknown error decoding chat rooms from JSON data: \(error)")
            }
            
            completion()
            }.resume()
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, sender: String, completion: @escaping () -> Void) {
        
        guard let index = chatRooms.index(of: chatRoom) else { completion(); return }
        
        let message = ChatRoom.Message(text: text, sender: sender)
        
        chatRooms[index].messages.append(message)
        
        let requestURL = ModelController.baseURL.appendingPathComponent(chatRoom.identifier).appendingPathComponent("messages").appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONEncoder().encode(message)
        } catch {
            NSLog("Error encoding message to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error with message thread creation data task: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
        
    }
    
    func fetchMessage(from chatRoom: ChatRoom, completion: @escaping () -> Void) {
        
    }
    
    static let baseURL = URL(string: "https://fir-chat-b24c0.firebaseio.com/")!
    var chatRooms: [ChatRoom] = []
    var currentUser: Sender?
    
}
