//
//  FlickrPhotoService.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

class FlickrPhotosService: NetworkFactory {
    func getRecent(page: Int?) async throws -> PhotosPaginatedResponse {
        let api: FlickrPhotosAPI = .getRecent(page: page)
        let response: PhotosResponseWrapper<PhotosPaginatedResponse> = try await makeRequest(api)
        return response.photos
    }
    
    func getInfo(photoID: String, secret: String?) async throws -> GetInfoResponse {
        let api: FlickrPhotosAPI = .getInfo(photoID: photoID, secret: secret)
        let response: PhotoResponseWrapper<GetInfoResponse> = try await makeRequest(api)
        return response.photo
    }
    
    func searchTags(_ term: String, mode: TagSearchMode, page: Int?) async throws -> PhotosPaginatedResponse {
        let api: FlickrPhotosAPI = .search(searchTerm: term, tagMode: mode, page: page)
        let response: PhotosResponseWrapper<PhotosPaginatedResponse> = try await makeRequest(api)
        return response.photos
    }
}

