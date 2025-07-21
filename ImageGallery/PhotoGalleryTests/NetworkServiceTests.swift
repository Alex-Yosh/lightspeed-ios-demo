//
//  NetworkServiceTests.swift
//  PhotoGalleryTests
//
//  Created by Alex Yoshida on 2025-07-21.
//

import Testing
import Foundation
@testable import PhotoGallery

@MainActor
struct NetworkServiceTests {
    
    // MARK: - Mock
    
    class MockURLProtocol: URLProtocol {
        static var stubResponseData: Data?
        static var stubError: Error?
        static var stubStatusCode: Int = 200
        
        override class func canInit(with request: URLRequest) -> Bool {
            true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            request
        }
        
        override func startLoading() {
            guard let client = client else { return }
            
            if let error = Self.stubError {
                client.urlProtocol(self, didFailWithError: error)
            } else if let url = request.url {
                let response = HTTPURLResponse(
                    url: url,
                    statusCode: Self.stubStatusCode,
                    httpVersion: nil,
                    headerFields: nil
                )!
                
                client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                
                if let data = Self.stubResponseData {
                    client.urlProtocol(self, didLoad: data)
                }
                
                client.urlProtocolDidFinishLoading(self)
            } else {
                client.urlProtocol(self, didFailWithError: URLError(.badURL))
            }
        }
        
        
        override func stopLoading() {}
    }
    
    // MARK: - NetworkService with mockURL
    
    func makeMockNetworkService(
        data: Data?,
        statusCode: Int = 200,
        error: Error? = nil
    ) -> NetworkService {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        MockURLProtocol.stubResponseData = data
        MockURLProtocol.stubError = error
        MockURLProtocol.stubStatusCode = statusCode
        
        return NetworkService(session: session)
    }
    
    // MARK: - Tests
    
    @Test
    func testFetchPhotosSuccess() async throws {
        
        // Arrange
        let sampleJSON = """
        [
            {
                "id":"0","author":"Alejandro Escamilla","width":5000,"height":3333,"url":"https://unsplash.com/photos/yC-Yzbqy7PY","download_url":"https://picsum.photos/id/0/5000/3333"
            }
        ]
        """.data(using: .utf8)
        
        // Act
        let service = makeMockNetworkService(data: sampleJSON, statusCode: 200)
        
        let photos = try await service.fetchPhotos()
        
        //Assert
        #expect(photos.count == 1)
        #expect(photos[0].id == "0")
        #expect(photos[0].author == "Alejandro Escamilla")
    }
   
}
