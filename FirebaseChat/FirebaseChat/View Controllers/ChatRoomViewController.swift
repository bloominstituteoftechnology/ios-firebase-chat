//
//  ChatRoomViewController.swift
//  FirebaseChat
//
//  Created by Jake Connerly on 10/15/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    // MARK: - IBOutlets & Properties

    @IBOutlet weak var tableView: UITableView!
    let messageThreadController = MessageThreadController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
