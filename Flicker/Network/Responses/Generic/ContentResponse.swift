//
//  ContentResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import Foundation

struct ContentResponse: Decodable {
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.content = try container.decode(String.self, forKey: .content)
    }
}
