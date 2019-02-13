import Foundation
import MessageKit
import Firebase
import FirebaseDatabase

class ChatRoomController {
    
    var chatRooms: [ChatRoom] = []
    var currentUser: Sender?
    
    let baseURL = URL(string: "FIXME!!!!!!!!")!
    
    
    func fetchChatRooms(completion: @escaping () -> Void) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Unable to fetch chatrooms: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned.")
                completion()
                return
            }
            
            do {
                let decoder: JSONDecoder = JSONDecoder()
                self.chatRooms = try decoder.decode([String: ChatRoom].self, from: data).map({ $0.value })
            }catch {
                NSLog("Unable to decode JSON: \(error)")
                self.chatRooms = []
            }
            completion()
            return
        }.resume()
    }
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        
        let chatRoom = ChatRoom(title: title)
        let requestURL = baseURL.appendingPathComponent(chatRoom.identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(chatRoom)
        }catch {
            NSLog("Unable to encode to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Unable to save chat room to server: \(error)")
                completion()
                return
            }
            
            self.chatRooms.append(chatRoom)
            completion()
            return
            
        }.resume()
        
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, from senderName: String, completion: @escaping () -> Void) {
        
        guard let index = chatRooms.index(of: chatRoom) else {
            completion()
            return
        }
        
        let message = ChatRoom.Message(text: text, senderName: senderName)
        chatRooms[index].messages.append(message)
        
        let requestURL = baseURL.appendingPathComponent(chatRoom.identifier).appendingPathComponent("messages").appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(message)
        }catch {
            NSLog("Error encoding message to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error posting message in chatroom: \(error)")
                completion()
                return
            }
            completion()
            return
        }.resume()
    }
    
//    func fetchMessages(from chatRoom: ChatRoom) {
//
//    }
    
    
}
