//
//  PhotoGalleryViewModel.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import Foundation
import CoreData
import SwiftUI

@MainActor
protocol PhotoGalleryViewModelProtocol: ObservableObject {
    var photos: [PhotoItem] { get set }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var isEditMode: Bool { get set }
    
    func fetchRandomPhoto() async
    func deletePhoto(_ photo: PhotoItem) async
    func toggleEditMode()
    func clearError()
}

@MainActor
final class PhotoGalleryViewModel: PhotoGalleryViewModelProtocol {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var photos: [PhotoItem] = []
    @Published var isEditMode: Bool = false

    private let context: NSManagedObjectContext
    private let photoRepository: PhotoRepositoryProtocol
    private var gallery: Gallery?
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.photoRepository = PhotoRepository(context: context)
        
        // Setup observers and load initial data
        setupDataObservation()
        loadInitialData()
    }
    
    
    // MARK: - Actions
    
    func fetchRandomPhoto() async {
        isLoading = true
        
        do {
            try await photoRepository.fetchAndSaveRandomPhoto()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func deletePhoto(_ photo: PhotoItem) async {
        do {
            try await photoRepository.deletePhoto(photo)
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
    
    func clearError() {
        errorMessage = nil
    }
    
    // MARK: - UI Setup
    
    private func setupDataObservation() {
        photoRepository.startObservingDataChanges { [weak self] in
            self?.refreshUI()
        }
    }
    
    private func loadInitialData() {
        do {
            gallery = try photoRepository.fetchGallery()
            refreshUI()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func refreshUI() {
        guard let gallery = gallery else { return }
        photos = photoRepository.getCurrentPhotos(from: gallery)
    }
    
    private func exitEditMode() {
        guard let gallery = gallery else { return }
        
        do {
            try photoRepository.exitEditMode(currentPhotos: photos, gallery: gallery)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
