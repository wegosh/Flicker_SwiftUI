//
//  UserWrapperResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import Foundation

struct UserWrapperResponse<T: Decodable>: Decodable {
    let user: T
    let stat: String
    
    enum CodingKeys: String, CodingKey {
        case user, stat
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user = try container.decode(T.self, forKey: .user)
        self.stat = try container.decode(String.self, forKey: .stat)
    }
}
