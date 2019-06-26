//
//  AppDelegate.swift
//  firebase-chat
//
//  Created by Hector Steven on 6/25/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()
//		RoomsController().testpush()
		RoomsController().test2get()
		return true
	}

}

