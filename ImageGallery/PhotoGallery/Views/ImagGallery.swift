//
//  ImageGallery.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import SwiftUI
import CoreData

struct ImagGallery<ViewModel: ImageGalleryViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        VStack() {
            // Header
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Gallery")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("\(viewModel.images.count) photos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Text("Edit")
                    }
                }
                
                Button(action: {
                    Task { await viewModel.fetchRandomImage() }
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text("Add Random Photo")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 16)
            .padding(.horizontal, 8)
            .background(Color(.systemBackground))
            
            // Photos
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.images, id: \.self) { photo in
                        ImageCardView(photo: photo)
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
    let viewModel = ImageGalleryViewModel(context: context)
    
    ImagGallery(viewModel: viewModel)
        .environment(\.managedObjectContext, context)
}
