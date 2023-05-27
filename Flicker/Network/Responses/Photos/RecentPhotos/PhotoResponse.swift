//
//  PhotoResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

struct PhotoResponse: Decodable, Hashable, Identifiable, SortableResponse {
    let fetchedAt: Date
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let isPublic: Bool
    let isFriend: Bool
    let isFamily: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.owner = try container.decode(String.self, forKey: .owner)
        self.secret = try container.decode(String.self, forKey: .secret)
        self.server = try container.decode(String.self, forKey: .server)
        self.farm = try container.decode(Int.self, forKey: .farm)
        self.isPublic = try container.decode(Int.self, forKey: .isPublic) == 1
        self.isFriend = try container.decode(Int.self, forKey: .isFriend) == 1
        self.isFamily = try container.decode(Int.self, forKey: .isFamily) == 1
        
        self.fetchedAt = .now
    }
}

extension PhotoResponse {
    func imageURL(size: ImageSize) -> URL? {
        return GetImageURL().imageURL(from: self, size: size)
    }
}
