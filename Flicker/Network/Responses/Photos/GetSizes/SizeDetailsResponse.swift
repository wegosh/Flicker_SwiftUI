//
//  SizeDetailsResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

struct SizeDetailsResponse: Decodable {
    let canBlog: Bool
    let canDownload: Bool
    let canPrint: Bool
    let sizes: [SizeResponse]
    
    enum CodingKeys: String, CodingKey {
        case canBlog = "canblog"
        case canDownload = "candownload"
        case canPrint = "canprint"
        case sizes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.canBlog = try container.decode(Int.self, forKey: .canBlog) == 1
        self.canDownload = try container.decode(Int.self, forKey: .canDownload) == 1
        self.canPrint = try container.decode(Int.self, forKey: .canPrint) == 1
        self.sizes = try container.decode([SizeResponse].self, forKey: .sizes)
    }
}
