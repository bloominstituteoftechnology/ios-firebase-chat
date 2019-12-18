//
//  NetworkError.swift
//  FirebaseChat
//
//  Created by Jon Bash on 2019-12-17.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noDecode
    case noEncode
    case badData
    case timeout
    case other(Error?)
}
