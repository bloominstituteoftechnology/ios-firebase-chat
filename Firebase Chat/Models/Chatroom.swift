
//
//  Chatroom.swift
//  Firebase Chat
//
//  Created by Michael Redig on 6/18/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

struct Chatroom: PortableDictionaryProtocol {
	static var decoder: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .secondsSince1970
		return decoder
	}

	static var encoder: JSONEncoder {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .secondsSince1970
		return encoder
	}

	let topic: String
	let created: Date
	let id: UUID
}
