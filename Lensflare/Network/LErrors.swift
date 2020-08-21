//
//  LErrors.swift
//  Lensflare
//
//  Created by Oguz on 21.08.2020.
//

import Foundation
enum LErrors: String,Error {
    case invalidURL             = "Can't create url"
    case unableToComplete       = "Unable the complete request.Please check your connection"
    case invalidResponse        = "Invalid response from the server.Please try again"
    case invalidData            = "The recevied data from server was invalid.Please try agin"
    case connectionError        = "Connection error.Please try again"
}
