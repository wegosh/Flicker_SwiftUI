//
//  FlickrPeopleAPI.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import Foundation

enum FlickrPeopleAPI: NetworkAPIFactory {
    var method: HTTPMethod {
        switch self {
        case .getPhotos:
            return .get
        }
    }
    
    var path: String {
        return "services/rest"
    }
    
    var parameters: [String : String] {
        switch self {
        case .getPhotos(userID: let id, page: let page):
            var params = [
                "user_id": id,
                "method": "flickr.people.getRecent",
            ]
            params["per_page"] = String(20)
            params["extras"] = ["tags", "owner_name", "icon_server"].joined(separator: ", ")
            if let page {
                params["page"] = String(page)
            }
            return params
        }
    }
    
    case getPhotos(userID: String, page: Int?)
}
