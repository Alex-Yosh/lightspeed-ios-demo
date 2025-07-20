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
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.images, id: \.self) { photo in
                        ImageCardView(photo: photo)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    let persistence = PersistenceController.preview
    let context = persistence.container.viewContext
    let viewModel = ImageGalleryViewModel(context: context)
    
    ImagGallery(viewModel: viewModel)
        .environment(\.managedObjectContext, context)
}
