//
//  UserImageListViewModel.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 28/05/2023.
//

import SwiftUI

class UserImageListViewModel: ObservableObject, StatefulViewModel {
    // MARK: - Published Properties
    @Published var state: ViewState = .initial
    @Published var pictures: [PhotoResponse] = []
    @Published var imagesHaveNextPage: Bool = true
    @Published var showImageDetails: Bool = false
    @Published var selectedResponse: PhotoResponse?
    @Published var userID: String?
    
    // MARK: - Variables
    private let service: FlickrPeopleService
    private var imagePage: Int = 1
    private var currentPictureIDs: Set<String> = []
    private var isLoadingMore: Bool = false
    
    // MARK: - Initializers
    init() {
        self.service = .init()
    }
    
    init(service: FlickrPeopleService) {
        self.service = service
    }
    
    // MARK: - Functionality
    @MainActor
    func fetchImages() async {
        do {
            guard let userID else { return }
            guard state != .loading else { return }
            guard imagesHaveNextPage else { return }
            await setViewState(.loading)
            let response = try await service.getPhotos(id: userID, page: imagePage)
            
            imagesHaveNextPage = response.pages > imagePage
            
            if imagesHaveNextPage {
                imagePage += 1
            }
            
            let newImages = response.photo.filter { !currentPictureIDs.contains($0.id) }
            currentPictureIDs.formUnion(newImages.map { $0.id })
            
            self.pictures.append(contentsOf: sortResponse(newImages))
            
            await setViewState(.initial)
        } catch {
            await setViewState(.error(message: error.localizedDescription))
        }
    }
    
    @MainActor
    func resetPage() async {
        pictures = []
        currentPictureIDs.removeAll()
        imagePage = 1
        imagesHaveNextPage = true
    }
    
    func loadMoreIfNeeded(currentItem item: PhotoResponse) {
        Task {
            guard let lastItem = pictures.last, lastItem.id == item.id, !isLoadingMore else { return }
            
            isLoadingMore = true
            await fetchImages()
            self.isLoadingMore = false
        }
    }
    
    func selectImage(_ photoResponse: PhotoResponse?) {
        DispatchQueue.main.async {
            self.selectedResponse = photoResponse
            self.showImageDetails.toggle()
        }
    }
                                
    private func sortResponse<R: SortableResponse>(_ response: [R]) -> [R] {
        let sorted = response.sorted(by: {$0.fetchedAt < $1.fetchedAt})
        return sorted
    }
    
    internal func setViewState(_ newState: ViewState) async {
        await MainActor.run {
            withAnimation {
                self.state = newState
            }
        }
    }
}
