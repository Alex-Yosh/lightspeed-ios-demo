//
//  ImageGalleryApp.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import SwiftUI

@main
struct ImageGalleryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let imageManager = ImageManager(context: persistenceController.container.viewContext)
            let viewModel = ImageGalleryViewModel(imageManager: imageManager)
            
            ContentView(viewModel: viewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
