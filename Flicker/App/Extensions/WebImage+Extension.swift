//
//  WebImage+Extension.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI

extension WebImage {
    var avatar: some View {
        self
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: 60, height: 60)
    }
}
