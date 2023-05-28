//
//  PhotoResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

struct PhotoResponse: Decodable, Hashable, Identifiable, SortableResponse {
    let fetchedAt: Date
    let id: String
    let owner: String
    let username: String
    let secret: String
    let server: String
    let farm: Int
    let isPublic: Bool
    let isFriend: Bool
    let isFamily: Bool
    let iconFarm: Int
    let iconServer: String
    let tags: String
    let title: String
    let profileIconURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
        case iconFarm = "iconfarm"
        case iconServer = "iconserver"
        case username = "ownername"
        case tags
        case title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.id = try container.decode(String.self, forKey: .id)
            self.owner = try container.decode(String.self, forKey: .owner)
            self.secret = try container.decode(String.self, forKey: .secret)
            self.server = try container.decode(String.self, forKey: .server)
            self.farm = try container.decode(Int.self, forKey: .farm)
            self.isPublic = try container.decode(Int.self, forKey: .isPublic) == 1
            self.isFriend = try container.decode(Int.self, forKey: .isFriend) == 1
            self.isFamily = try container.decode(Int.self, forKey: .isFamily) == 1
            
            self.iconServer = try container.decode(String.self, forKey: .iconServer)
            self.iconFarm = try container.decode(Int.self, forKey: .iconFarm)
            self.username = try container.decode(String.self, forKey: .username)
            self.tags = try container.decode(String.self, forKey: .tags)
            self.title = try container.decode(String.self, forKey: .title)
            
            self.fetchedAt = .now
            self.profileIconURL = GetImageURL().profileURL(farm: iconFarm, server: iconServer, ownerNSID: owner)
        } catch {
            print(error)
            throw error
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(secret)
        hasher.combine(server)
        hasher.combine(farm)
        hasher.combine(owner)
    }
}

extension PhotoResponse {
    func imageURL(size: ImageSize) -> URL? {
        return GetImageURL().imageURL(from: self, size: size)
    }
}
