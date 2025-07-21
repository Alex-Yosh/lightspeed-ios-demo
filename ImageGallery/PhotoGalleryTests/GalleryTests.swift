//
//  GalleryTests.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-21.
//

import Testing
import Foundation
@testable import PhotoGallery

@MainActor
struct GalleryTests {
    @Test
    func testAddPhotoAddsToGallery() {
        //Arrange
        let context = TestCoreDataManager.TestContext()
        let gallery = Gallery(context: context)
        let photo = PhotoItem(context: context)
        photo.id = "123"
        
        //Act
        gallery.addPhoto(photo)
        //Assert
        #expect(gallery.photosArray.contains(photo))
    }
    
    @Test
    func testRemovePhotoRemovesFromGallery() {
        //Arrange
        let context = TestCoreDataManager.TestContext()
        let gallery = Gallery(context: context)
        let photo = PhotoItem(context: context)
        photo.id = "123"
        gallery.addPhoto(photo)
        
        //Act
        gallery.removePhoto(photo)
        
        //Assert
        #expect(!gallery.photosArray.contains(photo))
    }
    
    @Test
    func testReplacePhotos() {
        //Arrange
        let context = TestCoreDataManager.TestContext()
        let gallery = Gallery(context: context)
        
        let photo1 = PhotoItem(context: context)
        photo1.id = "a"
        let photo2 = PhotoItem(context: context)
        photo2.id = "b"
        
        gallery.addPhoto(photo1)
        //Act
        gallery.replacePhotos(with: [photo2])
        
        //Assert
        #expect(gallery.photosArray == [photo2])
    }
    
}
