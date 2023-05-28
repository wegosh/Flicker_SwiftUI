//
//  FlickerApp.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import SwiftUI

@main
struct FlickerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack(root: {
                ImageListView()
            })
        }
    }
}
