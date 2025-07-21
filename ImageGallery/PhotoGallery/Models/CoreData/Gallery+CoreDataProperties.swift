//
//  Gallery+CoreDataProperties.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-20.
//
//

import Foundation
import CoreData

extension Gallery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gallery> {
        return NSFetchRequest<Gallery>(entityName: "Gallery")
    }

    @NSManaged public var photos: NSOrderedSet?

}
