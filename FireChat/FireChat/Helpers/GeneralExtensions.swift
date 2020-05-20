//
//  GeneralExtensions.swift
//  FireChat
//
//  Created by Ezra Black on 4/25/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

//import Foundation
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
