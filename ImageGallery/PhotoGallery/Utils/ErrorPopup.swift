//
//  ErrorPopup.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-21.
//

import SwiftUI
import PopupView

struct ErrorPopup: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let onDismiss: () -> Void
    
    func body(content: Content) -> some View {
        content
            .popup(isPresented: $isPresented) {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                    
                    Text("Error")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Done") {
                        isPresented = false
                        onDismiss()
                    }
                    .foregroundColor(.blue)
                }
                .padding(20)
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.2), radius: 10)
            } customize: {
                $0
                    .closeOnTapOutside(false)
                    .backgroundColor(.black.opacity(0.7))
            }
    }
}

extension View {
    func errorPopup(
        isPresented: Binding<Bool>,
        message: String,
        onDismiss: @escaping () -> Void = {}
    ) -> some View {
        modifier(ErrorPopup(
            isPresented: isPresented,
            message: message,
            onDismiss: onDismiss
        ))
    }
}

#Preview {
    VStack {
        Text("Content")
    }
    .errorPopup(
        isPresented: .constant(true),
        message: "Unable to add photo. Please try again."
    )
}
