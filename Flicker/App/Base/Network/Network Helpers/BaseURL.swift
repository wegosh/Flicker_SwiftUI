//
//  BaseURL.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

enum BaseURL {
    case appDefaultURL
    case customBase(stringURL: String)
    
    var url: String {
        switch self {
        case .appDefaultURL:
            return Configuration.baseURL.absoluteString
        case .customBase(let url):
            return url
        }
    }
}
