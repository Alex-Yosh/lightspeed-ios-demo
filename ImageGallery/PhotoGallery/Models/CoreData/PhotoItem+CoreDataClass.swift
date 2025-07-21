//
//  PhotoItem+CoreDataClass.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//
//

import Foundation
import CoreData

@objc(PhotoItem)
public class PhotoItem: NSManagedObject {
    
    convenience init(from picsumPhoto: PicsumPhoto, context: NSManagedObjectContext, gallery: Gallery? = nil) {
        self.init(context: context)
        self.id = picsumPhoto.id
        self.author = picsumPhoto.author
        self.width = Int32(picsumPhoto.width)
        self.height = Int32(picsumPhoto.height)
        self.url = picsumPhoto.url
        self.downloadURL = picsumPhoto.downloadURL
        self.gallery = gallery
    }
}
