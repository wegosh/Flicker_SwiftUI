//
//  DatesResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import Foundation

struct DatesResponse: Decodable {
    let posted: Date
    let taken: Date
    
    enum CodingKeys: CodingKey {
        case posted
        case taken
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let postedString = try container.decode(String.self, forKey: .posted)
        if let postedInterval = TimeInterval(postedString) {
            self.posted = Date(timeIntervalSince1970: postedInterval)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .posted, in: container, debugDescription: "Invalid date format")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = try container.decode(String.self, forKey: .taken)
        
        if let date = dateFormatter.date(from: dateString) {
            taken = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .taken, in: container, debugDescription: "Invalid date format")
        }
    }
}
