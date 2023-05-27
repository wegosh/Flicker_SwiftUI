//
//  ValidationError.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

enum ValidationError: Error, LocalizedError{
    case invalidParameter(name: String)
    case fieldsDoNotMatch(fields: [String])
    case unknown
    
    var errorDescription: String?{
        switch self {
        case .invalidParameter(let name):
            return "Parameter \(name) is invalid"
        case .fieldsDoNotMatch(fields: let fields):
            let mappedFields = fields.joined(separator: ", ")
            return "The following parameters do not match: \(mappedFields)"
        case .unknown:
            return "Unknown error occured"
        }
    }
}
