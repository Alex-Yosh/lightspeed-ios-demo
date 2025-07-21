//
//  PhotoGallery.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import SwiftUI
import CoreData
import SwiftUIReorderableForEach

struct PhotoGallery<ViewModel: PhotoGalleryViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    let columns = [
        GridItem(.flexible(minimum: 100), spacing: 12),
        GridItem(.flexible(minimum: 100), spacing: 12),
    ]
    
    private var photoCountText: String {
        "\(viewModel.photos.count) photos"
    }
    
    private var editButtonText: String {
        viewModel.isEditMode ? "Done" : "Edit"
    }
    
    private var addButtonText: String {
        viewModel.isLoading ? "Adding Photo..." : "Add Random Photo"
    }
    
    private var addButtonBackground: Color {
        viewModel.isLoading ? Color.gray : Color.blue
    }
    
    var body: some View {
        VStack() {
            // Header
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Gallery")
                            .font(.title)
                            .fontWeight(.bold)
                        Text(photoCountText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleEditMode()
                    }) {
                        Text(editButtonText)
                    }
                }
                
                Button(action: {
                    Task { await viewModel.fetchRandomPhoto() }
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "camera.fill")
                        }
                        Text(addButtonText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(addButtonBackground)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(viewModel.isLoading)
            }
            .padding(.horizontal, 16)
            .padding(.horizontal, 8)
            .background(Color(.systemBackground))
            
            // Photos
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ReorderableForEach(
                        $viewModel.photos,
                        allowReordering: $viewModel.isEditMode
                    ) { photo, isDragging in
                        PhotoCardView(
                            photo: photo,
                            isEditMode: viewModel.isEditMode,
                            onDelete: {
                                Task {
                                    await viewModel.deletePhoto(photo)
                                }
                            }
                        )
                        .scaleEffect(isDragging ? 1.05 : 1.0)
                        .opacity(isDragging ? 0.7 : 1.0)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    let persistence = PersistenceController.preview
    let context = persistence.container.viewContext
    let viewModel = PhotoGalleryViewModel(context: context)
    
    PhotoGallery(viewModel: viewModel)
        .environment(\.managedObjectContext, context)
}
