//
//  File.swift
//  Firebase Chat
//
//  Created by Michael Redig on 6/18/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation

protocol PortableDictionaryProtocol: Codable {
	static var decoder: JSONDecoder { get }
	static var encoder: JSONEncoder { get }

	func toDict() throws -> [String: Any]
	static func fromDict(_ dictionary: [String: Any]) throws -> Self
}

enum ToDictionaryError: Error {
	case conversionToDictionaryError
}

extension PortableDictionaryProtocol {

	func toDict() throws -> [String: Any] {
		let data = try Self.encoder.encode(self)

		guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
			throw ToDictionaryError.conversionToDictionaryError
		}

		return json
	}

	static func fromDict(_ dictionary: [String: Any]) throws -> Self {
		let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
		let value = try Self.decoder.decode(Self.self, from: jsonData)
		return value
	}
}
