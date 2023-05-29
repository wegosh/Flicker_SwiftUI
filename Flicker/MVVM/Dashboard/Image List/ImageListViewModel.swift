//
//  ImageListViewModel.swift
//  Flicker
//
//  Created by Patryk Wegrzynski Personal on 27/05/2023.
//

import SwiftUI
import Combine

class ImageListViewModel: ObservableObject, StatefulViewModel {
    // MARK: - Published Properties
    @Published var state: ViewState = .initial
    @Published var pictures: [PhotoResponse] = []
    @Published var imagesHaveNextPage: Bool = true
    @Published var showImageDetails: Bool = false
    @Published var showUserPhotos: Bool = false
    @Published var selectedResponse: PhotoResponse?
    @Published var selectedOwnerResponse: OwnerResponse?
    @Published var searchForText: String = ""
    @Published var toggleSearchMode: Bool = false
    @Published var pickerMode: PickerMode = .tags
    @Published var tagMode: TagSearchMode = .anyMatching
    @Published var personResponse: PersonResponse?
    
    // MARK: - Variables
    private let service: FlickrPhotosService
    private let peopleService: FlickrPeopleService = .init()
    private var imagePage: Int = 1
    private var currentPictureIDs: Set<String> = []
    private var isLoadingMore: Bool = false
    private var disposables: Set<AnyCancellable> = .init()
    
    // MARK: - Initializers
    init() {
        self.service = .init()
        observeSearchField()
    }
    
    init(_ photoService: FlickrPhotosService) {
        self.service = photoService
    }
    
    // MARK: - Functionality
    @MainActor
    func fetchImages() async {
        do {
            guard state != .loading else { return }
            guard imagesHaveNextPage else { return }
            await setViewState(.loading)
            let response = try await service.getRecent(page: imagePage)
            
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
    func fetchPhotosForTags(_ term: String, mode: TagSearchMode) async {
        do {
            guard state != .loading else { return }
            guard imagesHaveNextPage else { return }
            await setViewState(.loading)
            let response = try await service.searchTags(term, mode: mode, page: imagePage)
            
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
    func fetchPeople(_ username: String) async {
        do {
            guard state != .loading else { return }
            await setViewState(.loading)
            let response = try await peopleService.findByUsername(username)
            let userData = try await peopleService.getInfo(for: response.nsID)
            personResponse = userData
            
            await setViewState(.initial)
        } catch {
            personResponse = nil
            await setViewState(.error(message: error.localizedDescription))
        }
    }
    
    @MainActor
    func resetPageAsync() async {
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
    
    func selectProfile(from photoResponse: PhotoResponse?) {
        guard let photoResponse else { return }
        selectProfile(nsID: photoResponse.owner,
                      username: photoResponse.username,
                      realName: photoResponse.username,
                      location: nil,
                      iconServer: photoResponse.iconServer,
                      iconFarm: photoResponse.iconFarm)
    }
    
    func selectProfile(nsID: String,
                       username: String,
                       realName: String,
                       location: String?,
                       iconServer: String,
                       iconFarm: Int) {
        DispatchQueue.main.async {
            let ownerResponse = OwnerResponse(nsID: nsID,
                                              username: username,
                                              realName: realName,
                                              location: nil,
                                              iconServer: iconServer,
                                              iconFarm: iconFarm)
            self.selectedOwnerResponse = ownerResponse
            self.showUserPhotos.toggle()
        }
    }
    
    private func observeSearchField() {
        $searchForText
            .receive(on: RunLoop.main)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue: { value in
                self.searchFor(value, searchMode: self.pickerMode, tagMode: self.tagMode)
            })
            .store(in: &disposables)
    }
    
    private func searchFor(_ term: String, searchMode: PickerMode, tagMode: TagSearchMode) {
        Task {
            await resetPageAsync()
            if term.isEmpty {
                await fetchImages()
            } else {
                if searchMode == .tags {
                    await fetchPhotosForTags(term, mode: tagMode)
                } else {
                    await fetchPeople(term)
                }
            }
        }
    }
    
    func transformSearch() -> Binding<String> {
        return .init(get: {
            return self.searchForText
        }, set: { value in
            if self.pickerMode == .tags {
                self.searchForText = value.replacingOccurrences(of: " ", with: ",")
            } else {
                self.searchForText = value
            }
        })
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
    
    enum PickerMode: Int, CaseIterable {
        case tags
        case people
    }
}
