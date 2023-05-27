//
//  PhotosPaginatedResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

struct PhotosPaginatedResponse: Decodable {
    let page: Int
    let pages: Int
    let perPage: Int
    let total: Int
    let photo: [PhotoResponse]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perPage = "perpage"
        case total
        case photo
    }
}
