//
//  PersonResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import Foundation

struct PersonResponse: Decodable {
    let id: String
    let nsID: String
    let iconServer: String
    let iconFarm: Int
    let username: ContentResponse
    let realname: ContentResponse
    let location: ContentResponse
    let description: ContentResponse
    let imageURL: URL?
    let photos: Photos
    
    enum CodingKeys: String, CodingKey {
        case id
        case nsID = "nsid"
        case iconServer = "iconserver"
        case iconFarm = "iconfarm"
        case username
        case realname
        case location
        case description
        case photos
    }
    
    init(id: String, nsID: String, iconServer: String, iconFarm: Int, username: String, realname: String, location: String, description: String, photosCount: Int) {
        self.id = id
        self.nsID = nsID
        self.iconServer = iconServer
        self.iconFarm = iconFarm
        self.username = .init(username)
        self.realname = .init(realname)
        self.location = .init(location)
        self.description = .init(description)
        self.imageURL = GetImageURL().profileURL(farm: iconFarm, server: iconServer, ownerNSID: nsID)
        self.photos = .init(count: .init(photosCount))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.nsID = try container.decode(String.self, forKey: .nsID)
        self.iconServer = try container.decode(String.self, forKey: .iconServer)
        self.iconFarm = try container.decode(Int.self, forKey: .iconFarm)
        self.username = try container.decode(ContentResponse.self, forKey: .username)
        self.realname = try container.decodeIfPresent(ContentResponse.self, forKey: .realname) ?? .init("")
        self.location = try container.decodeIfPresent(ContentResponse.self, forKey: .location) ?? .init("")
        self.description = try container.decodeIfPresent(ContentResponse.self, forKey: .description) ?? .init("")
        self.photos = try container.decode(PersonResponse.Photos.self, forKey: .photos)
        self.imageURL = GetImageURL().profileURL(farm: iconFarm, server: iconServer, ownerNSID: nsID)
    }
}

extension PersonResponse {
    struct Photos: Decodable {
        let count: ContentResponse
    }
    
    static func previewContent() -> Self {
        return .init(id: "149567335@N07",
                     nsID: "149567335@N07",
                     iconServer: "5698",
                     iconFarm: 6,
                     username: "hcmsky",
                     realname: "HCM Sky Photo Archive",
                     location: "Hiroshima, Japan",
                     description: "Some description here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla interdum, metus vel feugiat sollicitudin, urna elit elementum massa, non varius mauris elit vel urna",
                     photosCount: 100)
    }
}
