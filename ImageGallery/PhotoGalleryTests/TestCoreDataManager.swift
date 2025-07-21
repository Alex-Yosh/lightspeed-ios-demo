//
//  TestCoreDataManager.swift
//  PhotoGalleryTests
//
//  Created by Alex Yoshida on 2025-07-21.
//

import CoreData
import Foundation
@testable import PhotoGallery

// Test helper to create singleton Core Data stack
@MainActor
final class TestCoreDataManager {
    static func TestContext() -> NSManagedObjectContext {
        let model = NSManagedObjectModel.mergedModel(from: [Bundle(for: PhotoItem.self)])!
        let container = NSPersistentContainer(name: "ImageGallery", managedObjectModel: model)

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory Core Data store: \(error)")
            }
        }

        return container.viewContext
    }
}
