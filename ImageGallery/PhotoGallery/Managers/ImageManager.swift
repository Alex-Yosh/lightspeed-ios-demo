//
//  ImageManager.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import Foundation
import CoreData

class ImageManager {
    private let networkService: NetworkServiceProtocol
    private let context: NSManagedObjectContext
    
    init(networkService: NetworkServiceProtocol = NetworkService(), context: NSManagedObjectContext) {
        self.networkService = networkService
        self.context = context
    }

    func fetchAndSaveRandomImage() async throws {
        // 1. Fetch images
        let photos = try await networkService.fetchImages()
        
        guard !photos.isEmpty else {
            throw ImageManagerError.noPhotosAvailable
        }
        
        // 2. Filter out duplicates
        let existingIds = try getExistingPhotoIds()
        let availablePhotos = photos.filter { !existingIds.contains($0.id) }
        
        // 3. Check if we have any new photos available
        guard let randomPhoto = availablePhotos.randomElement() else {
            throw ImageManagerError.allPhotosAlreadySaved
        }
        
        // 4. Create PhotoItem
        let _ = PhotoItem(from: randomPhoto, context: context)
        print(randomPhoto.author)
        
        // 5. Save to Core Data
        try context.save()
    }
    
    func fetchAllSavedPhotos() throws -> [PhotoItem] {
        let fetchRequest: NSFetchRequest<PhotoItem> = PhotoItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        return try context.fetch(fetchRequest)
    }
    
    // MARK: - Helpers
    
    private func getExistingPhotoIds() throws -> Set<String> {
        let fetchRequest: NSFetchRequest<PhotoItem> = PhotoItem.fetchRequest()
        let existingPhotos = try context.fetch(fetchRequest)
        return Set(existingPhotos.compactMap { $0.id })
    }
}

enum ImageManagerError: Error {
    case noPhotosAvailable
    case allPhotosAlreadySaved
    case saveFailed
}
