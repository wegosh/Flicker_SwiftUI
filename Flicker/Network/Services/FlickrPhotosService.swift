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
        let response: PhotosResponseWrapper = try await makeRequest(api)
        return response.photos
    }
    
    func getSizes(_ id: String) async throws -> [SizeResponse] {
        let api: FlickrPhotosAPI = .getSizes(photoID: id)
        let response: GetSizesWrapperResponse = try await makeRequest(api)
        return response.sizes.sizes
    }
}

