//
//  ViewController.swift
//  FirebaseChat
//
//  Created by Simon Elhoej Steinmejer on 18/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

class ChatRoomTableViewController: UITableViewController
{
    let didSetUsername = UserDefaults.standard.bool(forKey: "didSet")
    let username = UserDefaults.standard.string(forKey: "username")
    let userId = UserDefaults.standard.string(forKey: "userId")
    let chatRoomController = ChatRoomController()
    let cellId = "ChatRoom"
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if !didSetUsername
        {
            showUsernameAlert()
            UserDefaults.standard.set(true, forKey: "didSet")
        }
    }
    
    private func showUsernameAlert()
    {
        var usernameTextField: UITextField?
        let alert = UIAlertController(title: "Set username", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Username"
            usernameTextField = textField
        }
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            
            UserDefaults.standard.set("\(usernameTextField?.text ?? "Anonymous")", forKey: "username")
            UserDefaults.standard.set(UUID().uuidString, forKey: "userId")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        setupNavBar()
        
        chatRoomController.fetchChatRooms {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupNavBar()
    {
        title = "Chat Rooms"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewChatRoom))
    }

    @objc private func createNewChatRoom()
    {
        var nameTextField: UITextField?
        let alert = UIAlertController(title: "Set a chat room name", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            nameTextField = textField
        }
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            
            self.chatRoomController.createChatRoom(with: "\(nameTextField?.text ?? "blank")", completion: { (error) in
                
                if let _ = error
                {
                    //show alert
                    return
                }
            })
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return chatRoomController.chatRooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let chatRoom = chatRoomController.chatRooms[indexPath.row]
        
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.textLabel?.text = chatRoom.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let chatMessageViewController = ChatMessageViewController()
        let chatRoom = chatRoomController.chatRooms[indexPath.row]
        chatMessageViewController.chatRoom = chatRoom
        navigationController?.pushViewController(chatMessageViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }

}












