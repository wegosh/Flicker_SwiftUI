//
//  ExifResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import Foundation

struct ExifResponse: Decodable, Hashable, Equatable {
    static func == (lhs: ExifResponse, rhs: ExifResponse) -> Bool {
        return lhs.tag == rhs.tag && lhs.raw.content == rhs.raw.content
    }
    
    let id: String = UUID().uuidString
    let tagSpace: String
    let tagSpaceID: Int
    let tag: ExifTag
    let label: String
    let raw: ContentResponse
    let clean: ContentResponse?
    
    enum CodingKeys: String, CodingKey {
        case tagSpace = "tagspace"
        case tagSpaceID = "tagspaceid"
        case tag
        case label
        case raw
        case clean
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tagSpace = try container.decode(String.self, forKey: .tagSpace)
        self.tagSpaceID = try container.decode(Int.self, forKey: .tagSpaceID)
        self.label = try container.decode(String.self, forKey: .label)
        self.raw = try container.decode(ContentResponse.self, forKey: .raw)
        self.clean = try container.decodeIfPresent(ContentResponse.self, forKey: .clean)
        let tagString = try container.decode(String.self, forKey: .tag)
        self.tag = ExifTag(rawValue: tagString) ?? .unknown
    }
    
    init(tagSpace: String, tagSpaceID: Int, tag: ExifTag, label: String, raw: ContentResponse, clean: ContentResponse?) {
        self.tagSpace = tagSpace
        self.tagSpaceID = tagSpaceID
        self.tag = tag
        self.label = label
        self.raw = raw
        self.clean = clean
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(tag.rawValue)
        hasher.combine(raw.content)
    }
}

extension ExifResponse {
    static func previewContent() -> Self {
        return .init(
            tagSpace: "TagSpace",
            tagSpaceID: 123,
            tag: .make,
            label: "Label",
            raw: .init("RawContent"),
            clean: .init("CleanContent")
        )
    }
}

enum ExifTag: String, Decodable {
    case make = "Make"
    case model = "Model"
    case exposureTime = "ExposureTime"
    case aperture = "FNumber"
    case exposureProgram = "ExposureProgram"
    case iso = "ISO"
    case focalLength = "FocalLength"
    case unknown
}
