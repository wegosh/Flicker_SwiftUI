//
//  NetworkRequestFactory.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

protocol NetworkRequestFactory{
    func makeRequest<T: Decodable>(_ api: NetworkAPIFactory) async throws -> T
}
