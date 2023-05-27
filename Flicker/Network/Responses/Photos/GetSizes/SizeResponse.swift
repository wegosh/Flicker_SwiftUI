//
//  SizeResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

struct SizeResponse: Decodable {
    let label: SizeLabel
    let width: Int
    let height: Int
    let source: URL
    let url: URL
    let media: MediaType
    
    
    enum SizeLabel: String, Decodable {
        case square = "Square"
        case largeSquare = "Large Square"
        case thumbnail = "Thumbnail"
        case small = "Small"
        case small320px = "Small 320"
        case small400px = "Small 400"
        case medium = "Medium"
        case medium640px = "Medium 640"
        case medium800px = "Medium 800"
        case large = "Large"
    }
    
    enum MediaType: String, Decodable {
        case photo
    }
}
