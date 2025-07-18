//
//  ContentView.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: ImageGalleryViewModel

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PhotoItem.id, ascending: true)],
        animation: .default)
    private var savedPhotos: FetchedResults<PhotoItem>
    
    init(viewModel: ImageGalleryViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Text("Select an item")
        }.task {
            await viewModel.fetchRandomImage()
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let imageManager = ImageManager(context: context)
    let viewModel = ImageGalleryViewModel(imageManager: imageManager)
    
    ContentView(viewModel: viewModel)
        .environment(\.managedObjectContext, context)
}
