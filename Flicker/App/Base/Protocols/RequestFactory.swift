//
//  RequestFactory.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

protocol RequestFactory: Encodable {
    func validateRequest() async throws
}

extension RequestFactory {
    func data() throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let encodedData = try encoder.encode(self)
        return encodedData
    }
    
    func toJson() throws -> String {
        let data = try self.data()
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw CodingError.invalidJSON
        }
        return jsonString
    }
}
