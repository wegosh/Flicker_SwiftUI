//
//  PersonWrapperResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import Foundation

struct PersonWrapperResponse<T: Decodable>: Decodable {
    let person: T
    let stat: String
    
    enum CodingKeys: String, CodingKey {
        case person, stat
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.person = try container.decode(T.self, forKey: .person)
        self.stat = try container.decode(String.self, forKey: .stat)
    }
}
