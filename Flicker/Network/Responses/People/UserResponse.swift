//
//  UserResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import Foundation

struct UserResponse: Decodable {
    let id: String
    let nsID: String
    let username: ContentResponse
    
    enum CodingKeys: String, CodingKey {
        case id
        case nsID = "nsid"
        case username
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.nsID = try container.decode(String.self, forKey: .nsID)
        self.username = try container.decode(ContentResponse.self, forKey: .username)
    }
}
