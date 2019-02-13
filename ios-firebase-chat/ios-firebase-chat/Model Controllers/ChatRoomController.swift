import Foundation
import MessageKit
import Firebase

class ChatRoomController {
    
    var chatRooms: [ChatRoom] = []
    func fetchChatRooms(completion: @escaping () -> Void) {
        
    }
    
    func createChatRoom(with title: String, completion: @escaping () -> Void) {
        let chatRoom = ChatRoom(title: title)
    }
    
    func createMessage(in chatRoom: ChatRoom, withText text: String, from senderName: String, completion: @escaping () -> Void) {
        
    }
    
    func fetchMessages(from chatRoom: ChatRoom) {
        
    }
    
    
}
