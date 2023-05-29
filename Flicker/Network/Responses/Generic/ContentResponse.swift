//
//  ContentResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import Foundation

struct ContentResponse: Decodable, Equatable {
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
    
    init(_ content: String) {
        self.content = content
    }
    
    init(_ content: Int) {
        self.content = String(content)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let content = try? container.decode(String.self, forKey: .content) {
            self.content = content
        } else if let content = try? container.decode(Int.self, forKey: .content) {
            self.content = String(content)
        } else {
            self.content = ""
        }
    }
}
