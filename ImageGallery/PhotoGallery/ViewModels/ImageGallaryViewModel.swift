//
//  ImageGalleryViewModel.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import Foundation
import CoreData
import SwiftUI
import Combine

@MainActor
protocol ImageGalleryViewModelProtocol: ObservableObject {
    var images: [PhotoItem] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func fetchRandomImage() async
    func deletePhoto(_ photo: PhotoItem) async
    func deletePhotos(at indices: IndexSet) async
    func reorderPhotos(from source: Int, to destination: Int) async
}

@MainActor
final class ImageGalleryViewModel: ImageGalleryViewModelProtocol {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var images: [PhotoItem] = []
    private let context: NSManagedObjectContext
    
    private let imageRepository: ImageRepositoryProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.imageRepository = ImageRepository(context: context)
        
        // subscribe for when context changes
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: context)
                    .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
                    .sink { [weak self] _ in
                        self?.fetchSavedPhotos()
                    }
                    .store(in: &cancellables)
        
        // Load initial data
        fetchSavedPhotos()
    }
    
    func fetchRandomImage() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await imageRepository.fetchAndSaveRandomImage()
            print("Successfully fetched and saved random image")
        } catch {
            errorMessage = "Failed to fetch image: \(error.localizedDescription)"
            print("Failed to fetch and save random image with error: \(error)")
        }
        
        isLoading = false
    }
    
    func deletePhoto(_ photo: PhotoItem) async {
        // TODO: implement
    }
    
    func deletePhotos(at indices: IndexSet) async {
        // TODO: implement
    }
    
    func reorderPhotos(from source: Int, to destination: Int) async {
        // TODO: implement
    }
    
    private func fetchSavedPhotos() {
        do {
            images = try imageRepository.fetchAllSavedPhotos()
        } catch {
            errorMessage = "Failed to load photos: \(error.localizedDescription)"
        }
    }
}
