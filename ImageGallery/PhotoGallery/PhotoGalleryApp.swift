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

    var body: some Scene {
        WindowGroup {
            let viewModel = PhotoGalleryViewModel(context: persistantContext)
            
            PhotoGallery(viewModel: viewModel)
                .environment(\.managedObjectContext, persistantContext)
        }
    }
}
