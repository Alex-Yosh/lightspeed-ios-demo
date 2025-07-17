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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
