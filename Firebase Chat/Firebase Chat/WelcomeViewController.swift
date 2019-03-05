//
//  ViewController.swift
//  Firebase Chat
//
//  Created by Nelson Gonzalez on 3/5/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit


class WelcomeViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func SignInButtonPressed(_ sender: UIButton) {
        
        authService.loginAnnonimously(onSuccess: {
            self.performSegue(withIdentifier: "Show Chats", sender: nil)
        }) { (error) in
            print("Error signing up the user: \(error!.localizedDescription)")
        }
        
    }
    
}

