//
//  Persistence.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample PhotoItem data for previews
        let samplePhotos = [
            PicsumPhoto(
                id: "0",
                author: "Alejandro Escamilla",
                width: 5000,
                height: 3333,
                url: "https://unsplash.com/photos/yC-Yzbqy7PY",
                downloadURL: "https://picsum.photos/id/0/5000/3333"
            ),
            PicsumPhoto(
                id: "1",
                author: "Alejandro Escamilla",
                width: 5000,
                height: 3333,
                url: "https://unsplash.com/photos/LNRyGwIJr5c",
                downloadURL: "https://picsum.photos/id/1/5000/3333"
            ),
            PicsumPhoto(
                id: "10",
                author: "Paul Jarvis",
                width: 2500,
                height: 1667,
                url: "https://unsplash.com/photos/6J--NXulQCs",
                downloadURL: "https://picsum.photos/id/10/2500/1667"
            )
        ]
        
        for picsumPhoto in samplePhotos {
            let photoItem = PhotoItem(from: picsumPhoto, context: viewContext)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Preview data creation error: \(error)")
        }
        
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ImageGallery")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Handle the error appropriately in production but for this project its an edge case that is out of scope
                print("Core Data error: \(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
