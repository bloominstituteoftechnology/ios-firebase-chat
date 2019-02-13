//
//  ThreadsTableViewController.swift
//  ios-firebase-chat
//
//  Created by Benjamin Hakes on 2/12/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseCore

class ThreadsTableViewController: UITableViewController {
    
    var ref : DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        modelController.fetchThreadsFromFirebase(on: ref){
            DispatchQueue.main.async {
                self.dict = Model.shared.dictionary
                self.tableView.reloadData()
            }
            
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(dict)
        return dict?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadCell", for: indexPath)
        guard let textLabel = cell.textLabel else { fatalError("No cell text label") }
        textLabel.text = "Test"
        print(dict?[indexPath.row])
        // Configure the cell...

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: - Actions
    
    func getUserInput() {
        
        let alert = UIAlertController(title: "Enter A New Thread Title", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                guard let text = alert.textFields?[0].text else { return }
                let userThread = Thread(title: text)
                self.modelController.createThreadOnFirebase(thread: userThread, on: self.ref)
            case .cancel:
                return
            case .destructive:
                return
            }}))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func addThread(_ sender: Any) {
        getUserInput()
        
    }
    
    // MARK: - Properties
    var modelController: ModelController = ModelController()
    var threads: [Thread] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
