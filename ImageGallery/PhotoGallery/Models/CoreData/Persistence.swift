//
//  Persistence.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    // Expose sample Photos for preview use
    static let samplePhotos = [
        PicsumPhoto(
            id: "0",
            author: "Alejandro Escamilla",
            width: 5000,
            height: 3333,
            url: "https://unsplash.com/Photos/yC-Yzbqy7PY",
            downloadURL: "https://picsum.Photos/id/0/5000/3333"
        ),
        PicsumPhoto(
            id: "1",
            author: "Alejandro Escamilla",
            width: 5000,
            height: 3333,
            url: "https://unsplash.com/Photos/LNRyGwIJr5c",
            downloadURL: "https://picsum.Photos/id/1/5000/3333"
        ),
        PicsumPhoto(
            id: "10",
            author: "Paul Jarvis",
            width: 2500,
            height: 1667,
            url: "https://unsplash.com/Photos/6J--NXulQCs",
            downloadURL: "https://picsum.Photos/id/10/2500/1667"
        )
    ]
    
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create default gallery
        let defaultGallery = Gallery(context: viewContext)
        
        for picsumPhoto in samplePhotos {
            let PhotoItem = PhotoItem(from: picsumPhoto, context: viewContext, gallery: defaultGallery)
            defaultGallery.addPhoto(PhotoItem)
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
