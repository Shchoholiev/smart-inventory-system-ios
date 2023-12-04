//
//  HttpError.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import Foundation

struct HttpError: Error, Codable {
    let message: String
}
