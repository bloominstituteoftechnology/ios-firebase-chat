//
//  User+UserDefaults.swift
//  Message Board
//
//  Created by Michael Redig on 6/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MessageKit

struct User: SenderType {
	var id: UUID
	var senderId: String {
		return id.uuidString
	}
	var displayName: String
}

extension User: Codable {
	static func setDefault(sender: User) {
		let encoder = PropertyListEncoder()
		do {
			let data = try encoder.encode(sender)
			UserDefaults.standard.set(data, forKey: "DefaultSender")
		} catch {
			NSLog("Error saving default sender: \(error)")
		}
	}

	static func defaultSender() -> User? {
		guard let data = UserDefaults.standard.data(forKey: "DefaultSender") else { return nil }

		let decoder = PropertyListDecoder()
		return try? decoder.decode(User.self, from: data)
	}
}
