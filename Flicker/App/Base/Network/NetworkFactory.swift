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
            throw NetworkError.unauthenticated
        }
        
        if (200...299).contains(newHttpResponse.statusCode){
            let decoder = JSONDecoder()
            
            if let response = try? decoder.decode(T.self, from: newData) {
                return response
            } else if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let stat = json["stat"] as? String {
                if stat == "fail" {
                    if let errorMessage = json["message"] as? String {
                        throw NetworkError.message(errorMessage)
                    }
                }
                throw NetworkError.unknown
            } else {
                throw NetworkError.unknown
            }
        } else {
            if let response = try? JSONDecoder().decode(BaseErrorResponse.self, from: newData){
                throw NetworkError.message(response.message)
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
            throw NetworkError.unauthenticated
        }
        
        if (200...299).contains(httpResponse.statusCode){
            let decoder = JSONDecoder()
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let stat = json["stat"] as? String {
                if stat == "fail" {
                    if let errorMessage = json["message"] as? String {
                        throw NetworkError.message(errorMessage)
                    } else {
                        throw NetworkError.unknown
                    }
                }
                return 
            } else {
                throw NetworkError.unknown
            }
        } else {
            if let response = try? JSONDecoder().decode(BaseErrorResponse.self, from: newData){
                throw NetworkError.message(response.message)
            } else {
                throw NetworkError.unknown
            }
        }
    }
}
