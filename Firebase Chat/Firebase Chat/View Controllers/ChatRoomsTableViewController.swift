
import UIKit
import MessageKit

class ChatRoomsTableViewController: UITableViewController {

    @IBOutlet weak var chatRoomTitleTextField: UITextField!
    
    let modelController = ModelController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        modelController.fetchChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createChatRoom(_ sender: Any) {
        
        chatRoomTitleTextField.resignFirstResponder()
        
        guard let chatRoomTitle = chatRoomTitleTextField.text else { return }
        
        chatRoomTitleTextField.text = ""
        
        modelController.createChatRoom(with: chatRoomTitle) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.chatRooms.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatroomcell", for: indexPath)

        cell.textLabel?.text = modelController.chatRooms[indexPath.row].title

        return cell
    }






    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewChatRoomMessages" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? MessageViewController else { return }
            
            destinationVC.modelController = modelController
            destinationVC.chatRoom = modelController.chatRooms[indexPath.row]
        }
    }


}
