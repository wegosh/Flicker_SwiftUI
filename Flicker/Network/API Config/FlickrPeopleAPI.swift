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
        case .getPhotos, .findByUsername, .getInfo:
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
                "method": "flickr.people.getPhotos",
            ]
            params["per_page"] = String(20)
            params["extras"] = ["tags", "owner_name", "icon_server"].joined(separator: ", ")
            if let page {
                params["page"] = String(page)
            }
            return params
        case .findByUsername(username: let username):
            let params = [
                "method": "flickr.people.findByUsername",
                "username": username
            ]
            return params
        case .getInfo(userID: let id):
            var params = [
                "user_id": id,
                "method": "flickr.people.getInfo",
            ]
            return params
        }
    }
    
    case getPhotos(userID: String, page: Int?)
    case findByUsername(username: String)
    case getInfo(userID: String)
}
