//
//  FloatingActionButton.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-21.
//

import SwiftUI
import LoadingButton

struct FloatingActionButton: View {
    let isLoading: Bool
    let onTap: () -> Void
    
    var body: some View {
        LoadingButton(
            action: onTap,
            isLoading: .constant(isLoading),
            style: LoadingButtonStyle(
                width: 72,
                height: 72,
                cornerRadius: 36,
                backgroundColor: .blue.opacity(0.75),
                loadingColor: .white,
                strokeWidth: 3
            )
        ) {
            Image(systemName: "camera.fill")
                .font(.title)
                .foregroundColor(.white)
        }
        .shadow(color: .blue.opacity(0.4), radius: 12, x: 0, y: 6)
        .padding(.trailing, 20)
        .padding(.bottom, 20)
        .accessibilityIdentifier("floating_action_button")
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                VStack() {
                    FloatingActionButton(
                        isLoading: false,
                        onTap: {}
                    )
                    
                    FloatingActionButton(
                        isLoading: true,
                        onTap: {}
                    )
                }
            }
        }
    }
}
