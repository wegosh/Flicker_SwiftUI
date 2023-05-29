//
//  ExifResponse.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import Foundation

struct ExifResponseWrapper: Decodable, Identifiable {
    let id: String
    let secret: String
    let farm: Int
    let camera: String
    let exif: [ExifResponse]
}

extension ExifResponseWrapper {
    static func previewContent() -> Self {
        return .init(id: "52931943102", secret: "b7452271f5", farm: 66, camera: "Nicon", exif: [.previewContent()])
    }
}
