//
//  ImageDetailViewModelTests.swift
//  FlickerTests
//
//  Created by Patryk Wegrzynski Personal on 29/05/2023.
//

import XCTest
import Combine
@testable import Flicker

class ImageDetailViewModelTests: XCTestCase {
    var viewModel: ImageDetailViewModel!
    var photosServiceMock: FlickrPhotosServiceMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        photosServiceMock = FlickrPhotosServiceMock()
        viewModel = ImageDetailViewModel(service: photosServiceMock)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        photosServiceMock = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchDetails_Success() {
        let id = "123"
        let secret = "abc"
        let expectedResponse = MockData.getInfoResponse
        
        photosServiceMock.getInfoResult = .success(expectedResponse)
        
        let expectation = XCTestExpectation(description: "Image details fetched")
        
        viewModel.fetchDetails(id, secret: secret)
        
        viewModel.$state
            .sink { state in
                if state == .initial {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModel.state, .initial)
        XCTAssertEqual(viewModel.imageDetails, expectedResponse)
    }
    
    func testFetchDetails_Failure() {
        let id = "123"
        let secret = "abc"
        let expectedError = MockError.someError
        
        photosServiceMock.getInfoResult = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Error occurred")
        
        viewModel.fetchDetails(id, secret: secret)
        
        viewModel.$state
            .sink { state in
                if case .error(let message) = state {
                    XCTAssertEqual(message, expectedError.localizedDescription)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(viewModel.state, .error(message: expectedError.localizedDescription))
        XCTAssertNil(viewModel.imageDetails)
    }
    
    func testFetchEXIFData_Success() {
        photosServiceMock.getExifResult = .success(MockData.getExifResult)
        
        let expectation = XCTestExpectation(description: "EXIF data fetched")
        
        viewModel.$state
            .sink { state in
                if state == .initial {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        Task {
            do {
                let id = "123"
                let secret = "456"
                try await viewModel.fetchEXIFData(id, secret: secret)
                XCTAssertNotNil(viewModel.exifData)
                // Add assertions for expected exifData values
            } catch {
                XCTFail("Fetching EXIF data failed with error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchEXIFData_Failure() {
        photosServiceMock.getExifResult = .failure(MockError.someError)
        
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
            let id = "123"
            let secret = "456"
            await viewModel.fetchEXIFData(id, secret: secret)
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Mocks
    
    class FlickrPhotosServiceMock: FlickrPhotosService {
        var getInfoResult: Result<GetInfoResponse, Error>?
        var getExifResult: Result<ExifResponseWrapper, Error>?
        
        override func getInfo(photoID: String, secret: String?) async throws -> GetInfoResponse {
            guard let result = getInfoResult else {
                throw MockError.unexpected
            }
            
            switch result {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
            }
        }
        
        override func getExif(photoID: String, secret: String?) async throws -> ExifResponseWrapper {
            guard let result = getExifResult else {
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
        static let getInfoResponse: GetInfoResponse = {
            return .previewContent()
        }()
        static let getExifResult: ExifResponseWrapper = {
            return .previewContent()
        }()
    }
}
