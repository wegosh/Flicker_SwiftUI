//
//  FlickrPeopleService.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import Foundation

class FlickrPeopleService: NetworkFactory {
    func getPhotos(id: String, page: Int?) async throws -> PhotosPaginatedResponse {
        let api: FlickrPeopleAPI = .getPhotos(userID: id, page: page)
        let response: PhotosResponseWrapper<PhotosPaginatedResponse> = try await makeRequest(api)
        return response.photos
    }
    
    func findByUsername(_ username: String) async throws -> UserResponse {
        let api: FlickrPeopleAPI = .findByUsername(username: username)
        let response: UserWrapperResponse<UserResponse> = try await makeRequest(api)
        return response.user
    }
}
