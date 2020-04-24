//
//  ViewController.swift
//  Firebase Chat
//
//  Created by David Wright on 4/24/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit
import MessageKit
import Firebase

class ViewController: UIViewController {

    var ref: DatabaseReference!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
    }


}

