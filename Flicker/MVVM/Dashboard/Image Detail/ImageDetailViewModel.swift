//
//  ImageDetailViewModel.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import SwiftUI

class ImageDetailViewModel: ObservableObject, StatefulViewModel {
    // MARK: - Published Properties
    @Published var state: ViewState = .loading
    @Published var imageDetails: GetInfoResponse?
    
    // MARK: - Variables
    private let service: FlickrPhotosService = .init()
    
    // MARK: - Functionality
    func fetchDetails(_ id: String, secret: String?) {
        Task {
            await setViewState(.loading)
            do {
                let response = try await service.getInfo(photoID: id, secret: secret)
                await MainActor.run {
                    imageDetails = response
                }
                await setViewState(.initial)
            } catch {
                await setViewState(.error(message: error.localizedDescription))
            }
        }
    }
    
    internal func setViewState(_ newState: ViewState) async {
        await MainActor.run {
            self.state = newState
        }
    }
}
