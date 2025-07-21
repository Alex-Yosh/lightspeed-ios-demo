//
//  ImageRepository.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import Foundation
import CoreData

protocol ImageRepositoryProtocol {
    func fetchAndSaveRandomImage() async throws
    func fetchGallery() throws -> Gallery
    func deletePhoto(_ photo: PhotoItem) async throws
    func exitEditMode(currentPhotos: [PhotoItem], gallery: Gallery) throws
    func getCurrentPhotos(from gallery: Gallery) -> [PhotoItem]
    func startObservingDataChanges(onDataChanged: @escaping () -> Void)
}

class ImageRepository: ImageRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let context: NSManagedObjectContext
    private var dataChangeObserver: NSObjectProtocol?
    
    init(networkService: NetworkServiceProtocol = NetworkService(), context: NSManagedObjectContext) {
        self.networkService = networkService
        self.context = context
    }
    
    deinit {
        // delete observer
        if let observer = dataChangeObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    func fetchAndSaveRandomImage() async throws {
        // 1. Fetch images
        let photos = try await networkService.fetchImages()
        
        guard !photos.isEmpty else {
            throw ImageRepositoryError.noPhotosAvailable
        }
        
        // 2. Filter out duplicates
        let existingIds = try getExistingPhotoIds()
        let availablePhotos = photos.filter { !existingIds.contains($0.id) }
        
        // 3. Check if we have any new photos available
        guard let randomPhoto = availablePhotos.randomElement() else {
            throw ImageRepositoryError.allPhotosAlreadySaved
        }
        
        // 4. Get or create gallery
        let gallery = try fetchGallery()
        
        // 5. Create PhotoItem and add to gallery
        let photoItem = PhotoItem(from: randomPhoto, context: context, gallery: gallery)
        gallery.addPhoto(photoItem)
        
        // 6. Save to Core Data
        try context.save()
    }
    
    // gets existing gallery or creates one if none exist
    func fetchGallery() throws -> Gallery {
        let fetchRequest: NSFetchRequest<Gallery> = Gallery.fetchRequest()
        
        if let existingGallery = try context.fetch(fetchRequest).first {
            return existingGallery
        } else {
            let gallery = Gallery(context: context)
            try context.save()
            return gallery
        }
    }
    
    func deletePhoto(_ photo: PhotoItem) async throws {
        if let gallery = photo.gallery {
            gallery.removePhoto(photo)
        }
        context.delete(photo)
        try context.save()
    }
    
    func exitEditMode(currentPhotos: [PhotoItem], gallery: Gallery) throws {
        gallery.replacePhotos(with: currentPhotos)
        try context.save()
    }
    
    func getCurrentPhotos(from gallery: Gallery) -> [PhotoItem] {
        return gallery.photosArray
    }
    
    func startObservingDataChanges(onDataChanged: @escaping () -> Void) {
        dataChangeObserver = NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextObjectsDidChange,
            object: context,
            queue: .main
        ) { _ in
            onDataChanged()
        }
    }
    
    // MARK: - Helpers
    
    private func getExistingPhotoIds() throws -> Set<String> {
        let fetchRequest: NSFetchRequest<PhotoItem> = PhotoItem.fetchRequest()
        let existingPhotos = try context.fetch(fetchRequest)
        return Set(existingPhotos.compactMap { $0.id })
    }
}

enum ImageRepositoryError: Error {
    case noPhotosAvailable
    case allPhotosAlreadySaved
    case saveFailed
}
