//
//  ImageListViewModelTests.swift
//  ImageListViewModelTests
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import XCTest
import Combine
@testable import Flicker

class ImageListViewModelTests: XCTestCase {
    var viewModel: ImageListViewModel!
    var photosServiceMock: FlickrPhotosServiceMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        photosServiceMock = FlickrPhotosServiceMock()
        viewModel = ImageListViewModel(photosServiceMock)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        photosServiceMock = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchImages_Success() {
        photosServiceMock.getRecentResult = .success(MockData.photosPaginatedResponse)
        
        let expectation = XCTestExpectation(description: "Images fetched")
        
        viewModel.$state
            .sink { state in
                if state == .initial {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        Task {
            do {
                try await viewModel.fetchImages()
                XCTAssertNotNil(viewModel.pictures)
                XCTAssertEqual(viewModel.pictures.count, 1)
            } catch {
                XCTFail("Fetching images failed with error: \(error)")
            }
        }
    }
    
    func testFetchImages_Failure() {
        photosServiceMock.getRecentResult = .failure(MockError.someError)
        
        let expectation = XCTestExpectation(description: "Error occurred")
        
        viewModel.$state
            .sink { state in
                if case .error(let message) = state {
                    XCTAssertEqual(message, MockError.someError.localizedDescription)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        Task {
            await viewModel.fetchImages()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    class FlickrPhotosServiceMock: FlickrPhotosService {
        var getRecentResult: Result<PhotosPaginatedResponse, Error>?
        
        override func getRecent(page: Int?) async throws -> PhotosPaginatedResponse {
            guard let result = getRecentResult else {
                throw MockError.unexpected
            }
            
            switch result {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
            }
        }
    }
    
    enum MockError: Error {
        case someError
        case unexpected
    }
    
    struct MockData {
        static let photosPaginatedResponse: PhotosPaginatedResponse = {
            return PhotosPaginatedResponse(page: 1, pages: 1, perPage: 20, total: 1, photo: [PhotoResponse.previewContent()])
        }()
    }
}
