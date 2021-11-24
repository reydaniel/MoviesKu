//
//  CustomError.swift
//  MoviesKu
//
//  Created by ReyDaniel on 20/11/21.
//

import Foundation

enum URLError: LocalizedError {
    case invalidResponse
    case addressUnreachable(URL)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server responded with garbage."
        case .addressUnreachable(let url):
            return "\(url.absoluteString) is unreachable."
        }
    }
}

enum DatabaseError: LocalizedError {
    case invalidInstance
    case requestfailed
    
    var errorDescription: String? {
        switch self {
        case .invalidInstance:
            return "Database can't instance."
        case .requestfailed:
            return "Your requeest failed."
        }
    }
}
