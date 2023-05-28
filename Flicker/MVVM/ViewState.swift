//
//  ViewState.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import Foundation
import SwiftUI

enum ViewState: Equatable {
    case initial
    case loading
    case success
    case error(message: String)
}

protocol StatefulViewModel {
    var state: ViewState { get set }
    
    func setViewState(_ newState: ViewState)
    func setViewState(_ newState: ViewState) async
}

extension StatefulViewModel {
    func setViewState(_ newState: ViewState) {
        Task {
            await setViewState(newState)
        }
    }
}
