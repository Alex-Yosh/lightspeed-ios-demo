//
//  WiggleEffect.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-20.
//

import SwiftUI

struct WiggleEffect: ViewModifier {
    var isWiggling: Bool
    @State private var angle: Double = 0
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: angle))
            .onAppear {
                if isWiggling {
                    startWiggling()
                }
            }
            .onChange(of: isWiggling) { _, newValue in
                if newValue {
                    startWiggling()
                } else {
                    stopWiggling()
                }
            }
    }
    
    private func startWiggling() {
        angle = 0.8
        withAnimation(.easeInOut(duration: 0.15).repeatForever(autoreverses: true)) {
            angle = -0.8
        }
    }
    
    private func stopWiggling() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            angle = 0
        }
    }
}
