//
//  UserImageListViewModelTests.swift
//  FlickerTests
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import XCTest
import Combine
@testable import Flicker

final class UserImageListViewModelTests: XCTestCase {
    var viewModel: UserImageListViewModel!
    var peopleServiceMock: FlickrPeopleServiceMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        peopleServiceMock = FlickrPeopleServiceMock()
        viewModel = UserImageListViewModel(service: peopleServiceMock)
        viewModel.userID = "owner1"
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel.userID = nil
        viewModel = nil
        peopleServiceMock = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchImages_Success() async throws {
        let photosResponse = MockData.photosResponse
        peopleServiceMock.getPhotosResult = .success(photosResponse)
        let expectation = XCTestExpectation(description: "Photos fetched")
        
        await viewModel.fetchImages()
        
        viewModel.$state
            .sink { state in
                if state == .initial {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        XCTAssertEqual(viewModel.state, .initial)
        XCTAssertEqual(viewModel.pictures, MockData.sortedPhotos)
    }
    
    func testFetchImages_CollectionNotMatched_Failure() async throws {
        let photosResponse = MockData.photosResponse
        peopleServiceMock.getPhotosResult = .success(photosResponse)
        let expectation = XCTestExpectation(description: "Photos fetched")

        await viewModel.fetchImages()

        viewModel.$state
            .sink { state in
                if state == .initial {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        XCTAssertEqual(viewModel.state, .initial)
        
        // Modify the sorted photos to contain different values
        let modifiedSortedPhotos: [PhotoResponse] = [
            // Modify the photo properties to differ from viewModel.pictures
            .init(fetchedAt: .now, id: "2", owner: "owner2", username: "user2", secret: "secret2", server: "server2", farm: 2, isPublic: false, isFriend: true, isFamily: true, iconFarm: 2, iconServer: "iconServer2", tags: "tag2", title: "title2", profileIconURL: nil)
        ]

        XCTAssertNotEqual(viewModel.pictures, modifiedSortedPhotos)
    }
    
    func testFetchImages_StateError_Failure() async throws {
        let photosResponse = MockData.photosResponse
        peopleServiceMock.getPhotosResult = .success(photosResponse)
        let expectation = XCTestExpectation(description: "Photos fetched")

        await viewModel.fetchImages()

        viewModel.$state
            .sink { state in
                if case .error(let message) = state {
                    XCTAssertEqual(message, MockError.someError.localizedDescription)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
    }
    
    // Mock implementation of FlickrPeopleService
    class FlickrPeopleServiceMock: FlickrPeopleService {
        var getPhotosResult: Result<PhotosPaginatedResponse, Error>?
        
        override func getPhotos(id: String, page: Int?) async throws -> PhotosPaginatedResponse {
            guard let result = getPhotosResult else {
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
    
    // Mock error for testing
    enum MockError: Error {
        case someError
        case unexpected
    }
    
    // Mock data for testing
    struct MockData {
        static let photosResponse: PhotosPaginatedResponse = {
            return .previewContent()
        }()
        
        static let sortedPhotos: [PhotoResponse] = {
            return [.previewContent()]
        }()
    }
}

