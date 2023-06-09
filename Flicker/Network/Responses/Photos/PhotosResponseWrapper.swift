//
//  ResponseWrapper.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

struct PhotosResponseWrapper<Response: Decodable>: Decodable {
    let photos: Response
    
    enum CodingKeys: CodingKey {
        case photos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.photos = try container.decode(Response.self, forKey: .photos)
        } catch {
            throw error
        }
    }
}

struct PhotoResponseWrapper<Response: Decodable>: Decodable {
    let photo: Response
    
    enum CodingKeys: CodingKey {
        case photo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.photo = try container.decode(Response.self, forKey: .photo)
        } catch {
            throw error
        }
    }
}
