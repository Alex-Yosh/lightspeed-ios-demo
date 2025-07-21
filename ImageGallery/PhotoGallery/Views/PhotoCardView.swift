//
//  PhotoCardView.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-20.
//


import SwiftUI
import ActivityIndicatorView
import CoreData

struct PhotoCardView: View {
    let photo: PhotoItem
    var isEditMode: Bool = false
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // Photo Section
            if let photoURL = URL(string: photo.downloadURL) {
                AsyncImage(url: photoURL) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.1))
                            .aspectRatio(1.2, contentMode: .fit)
                            .overlay(
                                ActivityIndicatorView(isVisible: .constant(true), type: .growingArc(.blue, lineWidth: 3))
                                    .frame(width: 30, height: 30)
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(1.2, contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure(_):
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red.opacity(0.1))
                            .aspectRatio(1.2, contentMode: .fit)
                            .overlay(
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                    .font(.title2)
                            )
                    @unknown default:
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red.opacity(0.1))
                            .aspectRatio(1.2, contentMode: .fit)
                            .overlay(
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                    .font(.title2)
                            )
                    }
                }
            }
            
            // Info section
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(photo.author)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    HStack {
                        Text("#\(photo.id)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(String(photo.width)) x \(String(photo.height))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(.systemGray6))
                            )
                    }
                }
            }
            .frame(height: 50)
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        .scaleEffect(isEditMode ? 0.92 : 1.0)
        .modifier(WiggleEffect(isWiggling: isEditMode))
        .accessibilityIdentifier("photo_card")
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Photo by \(photo.author)")
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let request: NSFetchRequest<PhotoItem> = PhotoItem.fetchRequest()
    
    if let photo = try? context.fetch(request).first {
        VStack(spacing: 16) {
            PhotoCardView(photo: photo, isEditMode: false)
            PhotoCardView(photo: photo, isEditMode: true)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    } else {
        Text("Not loading")
    }
}

