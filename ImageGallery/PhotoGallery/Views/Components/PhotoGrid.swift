//
//  PhotoGrid.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-21.
//

import SwiftUI
import SwiftUIReorderableForEach
import ActivityIndicatorView
import CoreData

struct PhotoGrid: View {
    @Binding var photos: [PhotoItem]
    let isEditMode: Bool
    let onDeletePhoto: (PhotoItem) -> Void
    
    let columns = [
        GridItem(.flexible(minimum: 100), spacing: 12),
        GridItem(.flexible(minimum: 100), spacing: 12),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ReorderableForEach(
                    $photos,
                    allowReordering: .constant(isEditMode)
                ) { photo, isDragging in
                    PhotoCardView(
                        photo: photo,
                        isEditMode: isEditMode,
                        onDelete: {
                            onDeletePhoto(photo)
                        }
                    )
                    .scaleEffect(isDragging ? 1.05 : 1.0)
                    .opacity(isDragging ? 0.7 : 1.0)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 80)
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let request: NSFetchRequest<PhotoItem> = PhotoItem.fetchRequest()
    let photos = (try? context.fetch(request)) ?? []
    
    PhotoGrid(
        photos: .constant(photos),
        isEditMode: false,
        onDeletePhoto: { _ in }
    )
    .environment(\.managedObjectContext, context)
}

