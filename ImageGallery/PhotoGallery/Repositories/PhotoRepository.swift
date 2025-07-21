//
//  PhotoRepository.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import Foundation
import CoreData

protocol PhotoRepositoryProtocol {
    func fetchAndSaveRandomPhoto() async throws
    func fetchGallery() throws -> Gallery
    func deletePhoto(_ photo: PhotoItem) async throws
    func exitEditMode(currentPhotos: [PhotoItem], gallery: Gallery) throws
    func getCurrentPhotos(from gallery: Gallery) -> [PhotoItem]
    func startObservingDataChanges(onDataChanged: @escaping () -> Void)
}

class PhotoRepository: PhotoRepositoryProtocol {
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

    func fetchAndSaveRandomPhoto() async throws {
        // 1. Fetch photos
        let photos = try await networkService.fetchPhotos()
        
        guard !photos.isEmpty else {
            throw PhotoRepositoryError.noPhotosAvailable
        }
        
        // 2. Filter out duplicates
        let existingIds = try getExistingPhotoIds()
        let availablePhotos = photos.filter { !existingIds.contains($0.id) }
        
        // 3. Check if we have any new photos available
        guard let randomPhoto = availablePhotos.randomElement() else {
            throw PhotoRepositoryError.allPhotosAlreadySaved
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
        do {
            if let gallery = photo.gallery {
                gallery.removePhoto(photo)
            }
            
            // Delete individual photo after removing from gallery
            context.delete(photo)
            try context.save()
            
        } catch _ as NSError {
            // Reset
            context.rollback()
            throw PhotoRepositoryError.deletePhotoFailed
        }
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

enum PhotoRepositoryError: Error, LocalizedError {
    case noPhotosAvailable
    case allPhotosAlreadySaved
    case deletePhotoFailed
    case photoNotFound
    case galleryUpdateFailed
    
    var errorDescription: String? {
        switch self {
        case .noPhotosAvailable:
            return "No photos available from PicSum"
        case .allPhotosAlreadySaved:
            return "All available photos have been added to your gallery"
        case .deletePhotoFailed:
            return "Unable to delete photo. Please try again."
        case .photoNotFound:
            return "Photo not found. It may have already been deleted."
        case .galleryUpdateFailed:
            return "Unable to update gallery. Please try again."
        }
    }
}
