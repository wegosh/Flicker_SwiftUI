//
//  ImageListViewModel.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import Foundation

class ImageListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var errorMessage: String?
    @Published var pictures: [PhotoResponse] = []
    @Published var imagesHaveNextPage: Bool = true
    
    // MARK: - Variables
    private let service: FlickrPhotosService = .init()
    private var imagePage: Int = 1
    
    // MARK: - Functionality
    func fetchImages() async {
        do {
            guard imagesHaveNextPage else { return }
            let response = try await service.getRecent(page: imagePage)
            await MainActor.run {
                imagesHaveNextPage = response.pages > imagePage
                if imagesHaveNextPage {
                    imagePage += 1
                }
                let currentPictures = Set(pictures)
                let newImages = Set(response.photo)
                let toAppend = Array(newImages.subtracting(currentPictures))
                self.pictures.append(contentsOf: sortResponse(toAppend))
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func resetPage() async {
        await MainActor.run {
            imagePage = 1
            imagesHaveNextPage = true
        }
    }
                                
    private func sortResponse<R: SortableResponse>(_ response: [R]) -> [R] {
        let sorted = response.sorted(by: {$0.fetchedAt < $1.fetchedAt})
        return sorted
    }
}
