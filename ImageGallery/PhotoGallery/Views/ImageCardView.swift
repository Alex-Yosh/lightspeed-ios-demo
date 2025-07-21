//
//  ImageCardView.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-20.
//


import SwiftUI

struct ImageCardView: View {
    let photo: PhotoItem
    var isEditMode: Bool = false
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // Image Section
            if let imageURL = URL(string: photo.downloadURL) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.1))
                            .aspectRatio(1.2, contentMode: .fit)
                            .overlay(
                                ProgressView()
                                    .scaleEffect(0.8)
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
        .overlay(
            // delete button on edit
            Group {
                if isEditMode {
                    Button(action: {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                        onDelete?()
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    .offset(x: -8, y: -8)
                    .transition(.scale.combined(with: .opacity))
                }
            },
            alignment: .topLeading
        )
        .scaleEffect(isEditMode ? 0.92 : 1.0)
        .modifier(WiggleEffect(isWiggling: isEditMode))
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    // test working and failing images
    let samplePicsumPhoto = PersistenceController.samplePhotos[0]
    let workingPhoto = PhotoItem(from: samplePicsumPhoto, context: context)
    
    let failedPhoto = PhotoItem(context: context)
    failedPhoto.id = "error"
    failedPhoto.author = "Test Error"
    failedPhoto.downloadURL = "invalid-url"
    failedPhoto.width = 1920
    failedPhoto.height = 1080
    
    return VStack(spacing: 16) {
        ImageCardView(photo: workingPhoto, isEditMode: false)
        
        ImageCardView(photo: failedPhoto, isEditMode: true)
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
