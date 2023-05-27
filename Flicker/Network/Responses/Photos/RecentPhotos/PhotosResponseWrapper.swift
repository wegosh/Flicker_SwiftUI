//
//  ResponseWrapper.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

struct PhotosResponseWrapper: Decodable {
    let photos: PhotosPaginatedResponse
}
