//
//  GetInfoResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import Foundation

struct GetInfoResponse: Decodable, Equatable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let safetyLevel: String
    let rotation: Int
    let originalSecret: String?
    let originalFormat: String?
    let owner: OwnerResponse
    let dates: DatesResponse
    let views: String
    let description: ContentResponse
    
    enum CodingKeys: String, CodingKey {
        case id
        case secret
        case server
        case farm
        case safetyLevel = "safety_level"
        case rotation
        case originalSecret = "originalsecret"
        case originalFormat = "originalformat"
        case owner
        case dates
        case views
        case description
    }
    
    init(id: String, secret: String, server: String, farm: Int, safetyLevel: String, rotation: Int, originalSecret: String?, originalFormat: String?, owner: OwnerResponse, dates: DatesResponse, views: String, description: ContentResponse) {
        self.id = id
        self.secret = secret
        self.server = server
        self.farm = farm
        self.safetyLevel = safetyLevel
        self.rotation = rotation
        self.originalSecret = originalSecret
        self.originalFormat = originalFormat
        self.owner = owner
        self.dates = dates
        self.views = views
        self.description = description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.id = try container.decode(String.self, forKey: .id)
            self.secret = try container.decode(String.self, forKey: .secret)
            self.server = try container.decode(String.self, forKey: .server)
            self.farm = try container.decode(Int.self, forKey: .farm)
            self.safetyLevel = try container.decode(String.self, forKey: .safetyLevel)
            self.rotation = try container.decode(Int.self, forKey: .rotation)
            self.originalSecret = try container.decodeIfPresent(String.self, forKey: .originalSecret)
            self.originalFormat = try container.decodeIfPresent(String.self, forKey: .originalFormat)
            self.owner = try container.decode(OwnerResponse.self, forKey: .owner)
            self.dates = try container.decode(DatesResponse.self, forKey: .dates)
            self.views = try container.decode(String.self, forKey: .views)
            self.description = try container.decodeIfPresent(ContentResponse.self, forKey: .description) ?? .init("")
        } catch {
            throw error
        }
    }
}

extension GetInfoResponse {
    func imageURL(size: ImageSize) -> URL? {
        return GetImageURL().imageURL(farm: self.farm, server: self.server, id: self.id, secret: self.secret, size: size)
    }
    
    static func previewContent() -> GetInfoResponse {
        return GetInfoResponse(
            id: "123456789",
            secret: "abcd1234",
            server: "test-server",
            farm: 1,
            safetyLevel: "safe",
            rotation: 0,
            originalSecret: "efgh5678",
            originalFormat: "jpg",
            owner: .previewContent(),
            dates: .previewContent(),
            views: "1000",
            description: ContentResponse("Sample description")
        )
    }
}
