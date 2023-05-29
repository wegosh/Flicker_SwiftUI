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

extension PhotosPaginatedResponse {
    static func previewContent() -> Self {
        return .init(page: 1, pages: 2, perPage: 10, total: 20, photo: [.previewContent()])
    }
}
