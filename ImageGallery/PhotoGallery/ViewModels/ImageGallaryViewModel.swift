//
//  ImageGalleryViewModel.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
protocol ImageGalleryViewModelProtocol: ObservableObject {
    var images: [PhotoItem] { get set }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var isEditMode: Bool { get set }
    
    func fetchRandomImage() async
    func deletePhoto(_ photo: PhotoItem) async
    func toggleEditMode()
}

@MainActor
final class ImageGalleryViewModel: ImageGalleryViewModelProtocol {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var images: [PhotoItem] = []
    @Published var isEditMode: Bool = false

    private let context: NSManagedObjectContext
    private let imageRepository: ImageRepositoryProtocol
    private var gallery: Gallery?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.imageRepository = ImageRepository(context: context)
        
        // Setup observers and load initial data
        setupDataObservation()
        loadInitialData()
    }
    
    
    // MARK: - Actions
    
    func fetchRandomImage() async {
        isLoading = true
        
        do {
            try await imageRepository.fetchAndSaveRandomImage()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func deletePhoto(_ photo: PhotoItem) async {
        do {
            try await imageRepository.deletePhoto(photo)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func toggleEditMode() {
        isEditMode.toggle()
        if !isEditMode {
            exitEditMode()
        }
    }
    
    // MARK: - UI Setup
    
    private func setupDataObservation() {
        imageRepository.startObservingDataChanges { [weak self] in
            self?.refreshUI()
        }
    }
    
    private func loadInitialData() {
        do {
            gallery = try imageRepository.fetchGallery()
            refreshUI()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func refreshUI() {
        guard let gallery = gallery else { return }
        images = imageRepository.getCurrentPhotos(from: gallery)
    }
    
    private func exitEditMode() {
        guard let gallery = gallery else { return }
        
        do {
            try imageRepository.exitEditMode(currentPhotos: images, gallery: gallery)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
