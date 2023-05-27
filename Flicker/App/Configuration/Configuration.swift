//
//  Configuration.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

struct Configuration {
    static let baseURL = URL(string: "https://www.flickr.com")!
    
    // MARK: - Values below should be hidden and/or not send to GIT
    static let apiKey = "7bf3b7e573b6da1dcc0746c4bebf0f39"
    static let apiSecret = "87662d275c2267e0"
}
