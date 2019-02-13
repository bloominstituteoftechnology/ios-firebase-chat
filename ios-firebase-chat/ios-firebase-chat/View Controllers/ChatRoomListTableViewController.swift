import UIKit
import MessageKit
import Firebase
import Foundation
import FirebaseDatabase

class ChatRoomListTableViewController: UITableViewController {
    let reuseIdentifier = "ChatroomCell"
    let chatRoomController = ChatRoomController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chatRoomController.fetchChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userNameAlert = UIAlertController(title: "Please enter your username:", message: nil, preferredStyle: .alert)
        var userNameTextField: UITextField?
        userNameAlert.addTextField { (textField) in
            textField.placeholder = "Username:"
            userNameTextField = textField
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            let name = userNameTextField?.text ?? "Anonymous"
            let user = Sender(id: name, displayName: name)
            self.chatRoomController.currentUser = user
        }
        
        userNameAlert.addAction(submitAction)
        present(userNameAlert, animated: true, completion: nil)
  
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomController.chatRooms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = chatRoomController.chatRooms[indexPath.row].title
        return cell
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let destinationVC = segue.destination as? ChatRoomViewController else { return }
        // Pass the selected object to the new view controller.
        destinationVC.chatRoomController = chatRoomController
        destinationVC.chatRoom = chatRoomController.chatRooms[indexPath.row]
        
    }
 
    // MARK: - Properties(@IBOutlets)
    @IBOutlet weak var chatRoomTitleTextField: UITextField!

    // MARK: - @IBActions
    
    @IBAction func createNewChatRoom(_ sender: Any) {
        chatRoomTitleTextField.resignFirstResponder()
        guard let chatRoomTitle = chatRoomTitleTextField.text else { return }
        chatRoomTitleTextField.text = ""
        chatRoomController.createChatRoom(with: chatRoomTitle) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
