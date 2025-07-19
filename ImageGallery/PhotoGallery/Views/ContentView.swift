//
//  ContentView.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import SwiftUI
import CoreData

struct ContentView<ViewModel: ImageGalleryViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack {
            if viewModel.images == []{
                Text("already added")
            }else{
                ForEach(viewModel.images, id: \.self){ image in
                    Text(image.author)
                }
            }
        }
        .task {
            await viewModel.fetchRandomImage()
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let viewModel = ImageGalleryViewModel(context: context)
    
    ContentView(viewModel: viewModel)
            .environment(\.managedObjectContext, context)
}
