//
//  OwnerResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import Foundation

struct OwnerResponse: Decodable {
    let nsID: String
    let username: String
    let realName: String
    let location: String?
    let iconServer: String
    let iconFarm: Int
    let profileIconURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case nsID = "nsid"
        case username
        case realName = "realname"
        case location
        case iconServer = "iconserver"
        case iconFarm = "iconfarm"
    }
    
    init(nsID: String, username: String, realName: String, location: String?, iconServer: String, iconFarm: Int) {
        self.nsID = nsID
        self.username = username
        self.realName = realName
        self.location = location
        self.iconServer = iconServer
        self.iconFarm = iconFarm
        self.profileIconURL = GetImageURL().profileURL(farm: iconFarm, server: iconServer, ownerNSID: nsID)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nsID = try container.decode(String.self, forKey: .nsID)
        self.username = try container.decode(String.self, forKey: .username)
        self.realName = try container.decode(String.self, forKey: .realName)
        self.location = try container.decodeIfPresent(String.self, forKey: .location)
        self.iconServer = try container.decode(String.self, forKey: .iconServer)
        self.iconFarm = try container.decode(Int.self, forKey: .iconFarm)
        self.profileIconURL = GetImageURL().profileURL(farm: iconFarm, server: iconServer, ownerNSID: nsID)
    }
}

extension OwnerResponse {
    static func previewContent() -> Self {
        return .init(nsID: "193220913@N03", username: "Al12XD.LU", realName: "Alonso", location: "Leicester, UK", iconServer: "65535", iconFarm: 66)
    }
}
