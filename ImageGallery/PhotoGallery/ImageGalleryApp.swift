//
//  ImageGalleryApp.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import SwiftUI

@main
struct ImageGalleryApp: App {
    let persistantContext = PersistenceController.shared.container.viewContext

    var body: some Scene {
        WindowGroup {
            let viewModel = ImageGalleryViewModel(context: persistantContext)
            
            ContentView(viewModel: viewModel)
                .environment(\.managedObjectContext, persistantContext)
        }
    }
}
