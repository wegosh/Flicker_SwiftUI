//
//  FlickerApp.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI

@main
struct FlickerApp: App {
    init() {
        let cache = SDImageCache(namespace: "cache")
        cache.config.maxMemoryCost = 100 * 1024 * 1024 // 100MB memory
        cache.config.maxDiskSize = 50 * 1024 * 1024 // 50MB disk
        SDImageCachesManager.shared.addCache(cache)
        SDWebImageManager.defaultImageCache = SDImageCachesManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(root: {
                ImageListView()
            })
        }
    }
}
