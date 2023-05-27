//
//  NetworkAPIFactory.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

protocol NetworkAPIFactory{
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var body: Data? { get }
    var requestFactory: RequestFactory? { get }
    var baseURL: BaseURL { get }
    var requestType: RequestType { get }
}

extension NetworkAPIFactory{
    var headers: [String: String]{
        return [:]
    }
    var parameters: [String: String]{
        return [:]
    }
    var body: Data?{
        return nil
    }
    var requestFactory: RequestFactory?{
        return nil
    }
    var baseURL: BaseURL{
        return .appDefaultURL
    }
    var requestType: RequestType{
        return .raw
    }
    var url: URL?{
        var urlComponents = URLComponents(string: baseURL.url)
        if !path.starts(with: "/"){
            urlComponents?.path = "/\(path)"
        } else {
            urlComponents?.path = path
        }
        urlComponents?.queryItems = parameters.count > 0 ? parameters.compactMap({.init(name: $0.key, value: $0.value)}) : nil
        guard let urlComponents = urlComponents,
              let url = urlComponents.url else { return nil }
        return url
    }
    
    func buildURLRequest() async throws -> URLRequest{
        var urlComponents = URLComponents(string: baseURL.url)
        if !path.starts(with: "/"){
            urlComponents?.path = "/\(path)"
        } else {
            urlComponents?.path = path
        }
        
        urlComponents?.queryItems = parameters.count > 0 ? parameters.compactMap({.init(name: $0.key, value: $0.value)}) : nil
        urlComponents?.queryItems?.append(.init(name: "api_key", value: Configuration.apiKey))
        urlComponents?.queryItems?.append(.init(name: "format", value: "json"))
        urlComponents?.queryItems?.append(.init(name: "nojsoncallback", value: "1"))
        
        guard let urlComponents = urlComponents,
              let url = urlComponents.url else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue.uppercased()
        request.allHTTPHeaderFields = headers
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        guard (body == nil && requestFactory == nil) || ((body == nil || requestFactory == nil ) && ((body == nil) != (requestFactory == nil)) ) else { throw NetworkError.invalidImplementation }
        
        if let contentType = requestType.contentTypeField{
            switch requestType{
            case .none:
                // Do nothing
                break
            default:
                if let body = body{
                    request.addValue(requestType.value, forHTTPHeaderField: contentType)
                    request.httpBody = body
                } else if let requestFactory{
                    request.addValue(requestType.value, forHTTPHeaderField: contentType)
                    try await requestFactory.validateRequest()
                    request.httpBody = try requestFactory.data()
                }
            }
        }
        
        return request
    }
}
