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
}
