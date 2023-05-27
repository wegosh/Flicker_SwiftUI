//
//  NetworkError.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

enum NetworkError: Error, LocalizedError{
    case invalidURL
    case invalidResponse
    case invalidImplementation
    case unauthenticated
    case unknown
    case message(_ message: String)
    
    var errorDescription: String?{
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .message(let message):
            return message
        case .unknown:
            return "Unknown network error occured"
        case .invalidImplementation:
            return "One or more functionalities were incorrectly implemented"
        case .unauthenticated:
            return "This action requires user authentication"
        }
    }
}
