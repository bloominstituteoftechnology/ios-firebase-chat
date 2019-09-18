//
//  Extensions.swift
//  LambdaChat
//
//  Created by Jeffrey Santana on 9/17/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

extension UITextField {
	var optionalText: String? {
		let trimmedText = self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
		return (trimmedText ?? "").isEmpty ? nil : trimmedText
	}
}

extension Date {
	var transformIsoToString: String {
		let formatter = ISO8601DateFormatter()
		return formatter.string(from: self)
	}
}

extension String {
	var transformToIsoDate: Date? {
		guard self != "" else { return nil }
		let formatter = ISO8601DateFormatter()
		return formatter.date(from: self)
	}
}
