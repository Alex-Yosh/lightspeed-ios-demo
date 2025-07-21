//
//  PhotoGallery.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import SwiftUI
import CoreData
import LoadingButton
import PopupView

struct PhotoGallery<ViewModel: PhotoGalleryViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            PhotoGalleryHeader(
                photoCount: viewModel.photos.count,
                isEditMode: viewModel.isEditMode,
                onToggleEditMode: {
                    viewModel.toggleEditMode()
                }
            )
            
            PhotoGrid(
                photos: $viewModel.photos,
                isEditMode: viewModel.isEditMode,
                onDeletePhoto: { photo in
                    Task {
                        await viewModel.deletePhoto(photo)
                    }
                }
            )
        }
        .overlay(
            FloatingActionButton(
                isLoading: viewModel.isLoading,
                onTap: {
                    Task { await viewModel.fetchRandomPhoto() }
                }
            ),
            alignment: .bottomTrailing
        )
        .disabled(viewModel.errorMessage != nil)
        .errorPopup(
            isPresented: .constant(viewModel.errorMessage != nil),
            message: viewModel.errorMessage ?? "An error occurred. Please try again.",
            onDismiss: {
                viewModel.clearError()
            }
        )
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let mockViewModel = PhotoGalleryViewModel(context: context)
    
    PhotoGallery(viewModel: mockViewModel)
        .environment(\.managedObjectContext, context)
}

