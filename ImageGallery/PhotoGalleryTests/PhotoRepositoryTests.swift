//  PhotoRepositoryTests.swift
//  PhotoGalleryTests
//
//  Created by Alex Yoshida on 2025-07-21.

import CoreData
import Testing
@testable import PhotoGallery

@MainActor
struct PhotoRepositoryTests {

    // MARK: - Helpers

    class MockNetworkService: NetworkServiceProtocol {
        var mockPhotos: [PicsumPhoto] = []
        var shouldThrow = false

        func fetchPhotos() async throws -> [PicsumPhoto] {
            if shouldThrow {
                throw URLError(.badServerResponse)
            }
            return mockPhotos
        }
    }

    // MARK: - Tests
    
    @Test
    func testFetchAndSaveRandomPhotoSuccess() async throws {
        // Arrange
        let context = TestCoreDataManager.TestContext()
        let mockService = MockNetworkService()
        mockService.mockPhotos = [
            PicsumPhoto(id: "1", author: "A", width: 100, height: 100, url: "a.com", downloadURL: "a.com/1")
        ]

        let repo = PhotoRepository(networkService: mockService, context: context)

        // Act
        try await repo.fetchAndSaveRandomPhoto()
        let gallery = try repo.fetchGallery()
        let photos = repo.getCurrentPhotos(from: gallery)

        // Assert
        #expect(photos.count == 1)
        #expect(photos[0].id == "1")
    }

    @Test
    func testFetchAndSaveRandomPhotoEmptyResponseThrows() async {
        // Arrange
        let context = TestCoreDataManager.TestContext()
        let mockService = MockNetworkService()
        // no images available
        mockService.mockPhotos = []

        let repo = PhotoRepository(networkService: mockService, context: context)

        // Act + Assert
        do {
            try await repo.fetchAndSaveRandomPhoto()
            #expect(Bool(false), "Expected error")
        } catch let error as PhotoRepositoryError {
            #expect(error == .noPhotosAvailable)
        } catch {
            #expect(Bool(false), "Unexpected error")
        }
    }

    @Test
    func testDeletePhotoSuccess() async throws {
        // Arrange
        let context = TestCoreDataManager.TestContext()
        let gallery = Gallery(context: context)
        let photo = PhotoItem(context: context)
        photo.id = "1"
        photo.author = "a"
        photo.width = 100
        photo.height = 100
        photo.url = "a.com"
        photo.downloadURL = "a.com/1"
        
        photo.gallery = gallery
        gallery.addPhoto(photo)
        try context.save()

        let repo = PhotoRepository(context: context)

        // Act
        try await repo.deletePhoto(photo)

        // Assert
        let remainingPhotos = repo.getCurrentPhotos(from: gallery)
        #expect(remainingPhotos.isEmpty)
    }
}
