//
//  NetworkFactory.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

class NetworkFactory: NetworkRequestFactory {
    private func makeRequest(with urlRequest: URLRequest) async throws -> (data: Data, response: URLResponse){
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        return (data, response)
    }
    
    func makeRequest<T: Decodable>(_ api: NetworkAPIFactory) async throws -> T {
        let request: URLRequest = try await api.buildURLRequest()
        let (data, response) = try await makeRequest(with: request)
        
        guard let httpResponse = response as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        let newHttpResponse = httpResponse
        let newData = data
        
        if newHttpResponse.statusCode == 401 || newHttpResponse.statusCode == 403 {
            // TODO: Throw unauthenticated exception
        }
        
        if (200...299).contains(newHttpResponse.statusCode){
            return try JSONDecoder().decode(T.self, from: newData)
        } else {
            if let response = try? JSONDecoder().decode(BaseErrorResponse.self, from: newData){
                throw NetworkError.message(response.error)
            } else {
                throw NetworkError.unknown
            }
        }
    }
    
    func makeRequest(_ api: NetworkAPIFactory) async throws {
        let request: URLRequest = try await api.buildURLRequest()
        let (data, response) = try await makeRequest(with: request)
        
        guard let httpResponse = response as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        let newHttpResponse = httpResponse
        let newData = data
        
        if newHttpResponse.statusCode == 401 || newHttpResponse.statusCode == 403 {
            // TODO: Throw unauthenticated exception
        }
        
        if (200...299).contains(httpResponse.statusCode){
            return
        } else {
            if let response = try? JSONDecoder().decode(BaseErrorResponse.self, from: newData){
                throw NetworkError.message(response.error)
            } else {
                throw NetworkError.unknown
            }
        }
    }
}
