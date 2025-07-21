//
//  Gallery+CoreDataClass.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-20.
//
//

import Foundation
import CoreData

@objc(Gallery)
public class Gallery: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        self.init(entity: Gallery.entity(), insertInto: context)
    }
    
    func addPhoto(_ photo: PhotoItem) {
        let mutablePhotos = self.mutableOrderedSetValue(forKey: "photos")
        mutablePhotos.add(photo)
    }
    
    func removePhoto(_ photo: PhotoItem) {
        let mutablePhotos = self.mutableOrderedSetValue(forKey: "photos")
        mutablePhotos.remove(photo)
    }
    
    func replacePhotos(with newPhotos: [PhotoItem]) {
        let mutablePhotos = self.mutableOrderedSetValue(forKey: "photos")
        mutablePhotos.removeAllObjects()
        for photo in newPhotos {
            mutablePhotos.add(photo)
        }
    }
    
    var photosArray: [PhotoItem] {
        return photos?.array as? [PhotoItem] ?? []
    }
}
