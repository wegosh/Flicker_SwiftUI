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
    @Published var exifData: ExifResponseWrapper?
    
    // MARK: - Variables
    private let service: FlickrPhotosService
    
    // MARK: - Initializers
    init() {
        self.service = .init()
    }
    
    init(service: FlickrPhotosService) {
        self.service = service
    }
    
    // MARK: - Functionality
    func fetchDetails(_ id: String, secret: String?, fetchExif: Bool = true) {
        Task {
            await setViewState(.loading)
            do {
                let response = try await service.getInfo(photoID: id, secret: secret)
                await MainActor.run {
                    imageDetails = response
                }
                if fetchExif {
                    await fetchEXIFData(id, secret: secret)
                }
                await setViewState(.initial)
            } catch {
                await setViewState(.error(message: error.localizedDescription))
            }
        }
    }
    
    func fetchEXIFData(_ id: String, secret: String?) async {
        await setViewState(.loading)
        do {
            let response = try await service.getExif(photoID: id, secret: secret)
            await MainActor.run {
                exifData = response
            }
            await setViewState(.initial)
        } catch {
            await setViewState(.error(message: error.localizedDescription))
        }
    }
    
    internal func setViewState(_ newState: ViewState) async {
        await MainActor.run {
            self.state = newState
        }
    }
}
