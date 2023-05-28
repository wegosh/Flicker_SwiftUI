//
//  BaseErrorResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

struct BaseErrorResponse: Decodable {
    let stat: String
    let code: Int
    let message: String
}
