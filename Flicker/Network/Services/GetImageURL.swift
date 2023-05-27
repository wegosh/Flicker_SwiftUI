//
//  GetImageURL.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

struct GetImageURL {
    func imageURL(from response: PhotoResponse, size: ImageSize) -> URL? {
        let stringURL = "https://farm\(response.farm).staticflickr.com/\(response.server)/\(response.id)_\(response.secret)\(size.suffix).jpg"
        return URL(string: stringURL)
    }
}

enum ImageSize: String {
    case thumbnailSquare75px = "s"
    case thumbnailSquare150px = "q"
    case thumbnail100px = "t"
    case small240px = "m"
    case small320px = "n"
    case small400px = "w"
    case medium = ""
    case medium640px = "z"
    case medium800px = "c"
    case large = "b"
    case large1600px = "h"
    case large2048px = "k"
    case extraLarge = "3k"
    case extraLarge4096px = "4k"
    case extraLarge5120px = "5k"
    case extraLarge6144px = "6k"
    case original = "o"
    
    var suffix: String {
        switch self {
        case .medium:
            return ""
        default:
            return "_\(self.rawValue)"
        }
    }
}
