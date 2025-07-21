//
//  PhotoGalleryApp.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import SwiftUI

@main
struct PhotoGalleryApp: App {
    let persistantContext = PersistenceController.shared.container.viewContext
    
    init() {
        if CommandLine.arguments.contains("--ui-testing") {
            PersistenceController.shared.reset()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            let viewModel = PhotoGalleryViewModel(context: persistantContext)
            
            PhotoGallery(viewModel: viewModel)
                .environment(\.managedObjectContext, persistantContext)
                .preferredColorScheme(.light)
        }
    }
}
