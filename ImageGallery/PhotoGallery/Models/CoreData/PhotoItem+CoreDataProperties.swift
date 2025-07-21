//
//  PhotoItem+CoreDataProperties.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//
//

import Foundation
import CoreData


extension PhotoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoItem> {
        return NSFetchRequest<PhotoItem>(entityName: "PhotoItem")
    }

    @NSManaged public var id: String
    @NSManaged public var author: String
    @NSManaged public var width: Int32
    @NSManaged public var height: Int32
    @NSManaged public var url: String
    @NSManaged public var downloadURL: String
    @NSManaged public var gallery: Gallery?

}

extension PhotoItem : Identifiable {

}
