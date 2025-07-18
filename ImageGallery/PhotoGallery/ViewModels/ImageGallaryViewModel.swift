//
//  ImageGalleryViewModel.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import Foundation
import CoreData

@MainActor
final class ImageGalleryViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let imageManager: ImageManager
    
    init(imageManager: ImageManager) {
        self.imageManager = imageManager
    }
    
    func fetchRandomImage() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await imageManager.fetchAndSaveRandomImage()
            print("Successfully fetched and saved random image")
        } catch {
            errorMessage = "Failed to fetch image: \(error.localizedDescription)"
            print("Failed to fetch and save random image with error: \(error)")
        }
        
        isLoading = false
    }
}
