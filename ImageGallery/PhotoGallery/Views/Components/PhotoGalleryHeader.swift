//
//  PhotoGalleryHeader.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-21.
//

import SwiftUI

struct PhotoGalleryHeader: View {
    let photoCount: Int
    let isEditMode: Bool
    let onToggleEditMode: () -> Void
    
    private var photoCountText: String {
        "\(photoCount) photos"
    }
    
    private var editButtonText: String {
        isEditMode ? "Done" : "Edit"
    }
    
    var body: some View {
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
                
                Button(action: onToggleEditMode) {
                    Text(editButtonText)
                }
                .accessibilityIdentifier("edit_mode_button")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    VStack {
        PhotoGalleryHeader(
            photoCount: 5,
            isEditMode: false,
            onToggleEditMode: {}
        )
        
        PhotoGalleryHeader(
            photoCount: 12,
            isEditMode: true,
            onToggleEditMode: {}
        )
    }
}
