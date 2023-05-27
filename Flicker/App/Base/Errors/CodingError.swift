//
//  CodingError.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

enum CodingError: Error, LocalizedError {
    case dataNotEncodable
    case invalidJSON
    
    var errorDescription: String? {
        switch self {
        case .dataNotEncodable:
            return "Data could not be encoded/decoded"
        case .invalidJSON:
            return "Invalid JSON string"
        }
    }
}
