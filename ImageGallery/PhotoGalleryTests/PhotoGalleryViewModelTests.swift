//
//  PhotoGalleryViewModelTests.swift
//  PhotoGalleryTests
//
//  Created by Alex Yoshida on 2025-07-21.
//

import Testing
import CoreData
@testable import PhotoGallery

@MainActor
struct PhotoGalleryViewModelTests {

    // MARK: - Helpers

    final class MockPhotoRepository: PhotoRepositoryProtocol {
        var shouldThrowError = false
        var errorToThrow: Error = PhotoRepositoryError.noPhotosAvailable
        var mockGallery: Gallery?
        var mockPhotos: [PhotoItem] = []
        var fetchCalled = false
        var deleteCalled = false

        var onDataChanged: (() -> Void)?

        func fetchAndSaveRandomPhoto() async throws {
            fetchCalled = true
            if shouldThrowError { throw errorToThrow }
        }

        func fetchGallery() throws -> Gallery {
            guard let gallery = mockGallery else { throw PhotoRepositoryError.galleryUpdateFailed }
            return gallery
        }

        func deletePhoto(_ photo: PhotoItem) async throws {
            deleteCalled = true
            if shouldThrowError { throw errorToThrow }
            if let index = mockPhotos.firstIndex(of: photo) {
                mockPhotos.remove(at: index)
            }
        }

        func exitEditMode(currentPhotos: [PhotoItem], gallery: Gallery) throws {
            if shouldThrowError { throw errorToThrow }
        }

        func getCurrentPhotos(from gallery: Gallery) -> [PhotoItem] {
            return mockPhotos
        }

        func startObservingDataChanges(onDataChanged: @escaping () -> Void) {
            self.onDataChanged = onDataChanged
        }
    }

    // MARK: - Tests

    @Test
    func testFetchRandomPhotoSuccess() async {
        // Arrange
        let context = TestCoreDataManager.TestContext()
        let repo = MockPhotoRepository()
        let gallery = Gallery(context: context)
        repo.mockGallery = gallery

        let vm = PhotoGalleryViewModel(context: context, repository: repo)

        // Act
        await vm.fetchRandomPhoto()

        // Assert
        #expect(repo.fetchCalled == true)
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }

    @Test
    func testFetchRandomPhotoFailure() async {
        // Arrange
        let context = TestCoreDataManager.TestContext()
        let repo = MockPhotoRepository()
        repo.shouldThrowError = true
        repo.errorToThrow = PhotoRepositoryError.noPhotosAvailable

        let vm = PhotoGalleryViewModel(context: context, repository: repo)

        // Act
        await vm.fetchRandomPhoto()

        // Assert
        #expect(vm.errorMessage == "No photos available from PicSum")
        #expect(vm.isLoading == false)
    }

    @Test
    func testDeletePhotoSuccess() async {
        // Arrange
        let context = TestCoreDataManager.TestContext()
        let repo = MockPhotoRepository()
        
        let gallery = Gallery(context: context)
        repo.mockGallery = gallery

        let photo = PhotoItem(context: context)
        gallery.addPhoto(photo)
        repo.mockPhotos = [photo]

        let vm = PhotoGalleryViewModel(context: context, repository: repo)

        // Act
        await vm.deletePhoto(photo)
        repo.onDataChanged?()

        // Assert
        #expect(repo.deleteCalled == true)
        #expect(vm.photos.isEmpty)
        #expect(vm.errorMessage == nil)
    }
}
