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
                    ZStack(alignment: .topLeading) {
                        PhotoCardView(
                            photo: photo,
                            isEditMode: isEditMode,
                            onDelete: {
                                onDeletePhoto(photo)
                            }
                        )
                        .scaleEffect(isDragging ? 1.05 : 1.0)
                        .opacity(isDragging ? 0.7 : 1.0)
                        .accessibilityIdentifier("photo_card_\(photo.id)")
                        
                        if isEditMode {
                            Button(action: { onDeletePhoto(photo) }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .frame(width: 24, height: 24)
                            }
                            .accessibilityIdentifier("delete_button_\(photo.id)")
                            .accessibilityLabel("Delete photo")
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 80)
        }
        .background(Color(.systemGroupedBackground))
        .accessibilityElement(children: .contain)
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

