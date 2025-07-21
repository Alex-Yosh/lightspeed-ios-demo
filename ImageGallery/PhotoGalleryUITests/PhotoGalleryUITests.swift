//
//  PhotoGalleryUITests.swift
//  PhotoGalleryUITests
//
//  Created by Alex Yoshida on 2025-07-17.
//

import XCTest

final class PhotoGalleryUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--ui-testing")
        app.launch()
    }
    
    // MARK: - Helper Methods
    
    private func waitForPhotoToLoad() -> Bool {
        //check 1
        let photoCard = app.otherElements["photo_card"]
        if photoCard.waitForExistence(timeout: 5) {
            return true
        }
        
        //check 2
        let photoCardsWithIds = app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH 'photo_card_'"))
        if photoCardsWithIds.count > 0 {
            return true
        }
        
        sleep(5)
        //return
        return photoCard.exists || photoCardsWithIds.count > 0
    }
    
    private func fetchPhoto() {
        let fab = app.buttons["floating_action_button"]
        XCTAssertTrue(fab.waitForExistence(timeout: 5), "floating_action_button should exist")
        fab.tap()
        XCTAssertTrue(waitForPhotoToLoad(), "Photo should load after fetching")
    }
    
    // MARK: - UI Tests
    
    func testCanFetchAndDisplayPhoto() {
        let fab = app.buttons["floating_action_button"]
        XCTAssertTrue(fab.waitForExistence(timeout: 2), "floating_action_button should exist")
        fab.tap()
        
        XCTAssertTrue(waitForPhotoToLoad(), "Photo should load and display")
    }
    
    func testCanToggleEditMode() {
        // Arrange - Add photo
        fetchPhoto()
        
        // Act - Toggle edit mode
        let editButton = app.buttons["edit_mode_button"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 5), "Edit button should exist")
        editButton.tap()
        
        // Assert - Delete button should appear for any photo
        let deleteButtonsWithPrefix = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'delete_button_'"))
        let anyDeleteButton = deleteButtonsWithPrefix.element
        XCTAssertTrue(anyDeleteButton.waitForExistence(timeout: 8), "Delete button should appear in edit mode")
        
        // Act - Edit mode off
        editButton.tap()
        
        // Give UI time to update
        sleep(2)
        
        // Assert - Delete button should disappear
        XCTAssertFalse(anyDeleteButton.exists, "Delete button should disappear when edit mode is off")
    }
    
    func testCanDeletePhotoInEditMode() {
        // Arrange - Add photo
        fetchPhoto()
        
        let editButton = app.buttons["edit_mode_button"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 5), "Edit button should exist")
        editButton.tap()
        
        // Wait for edit mode to activate and delete buttons to appear
        let deleteButtonsWithPrefix = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH 'delete_button_'"))
        let anyDeleteButton = deleteButtonsWithPrefix.element
        XCTAssertTrue(anyDeleteButton.waitForExistence(timeout: 8), "Delete button should appear in edit mode")
        
        // Count photos before deletion using both identifier patterns
        let photosBeforeWithIds = app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH 'photo_card_'")).count
        XCTAssertGreaterThan(photosBeforeWithIds, 0, "Should have at least one photo to delete")
        
        // Act - Delete the photo
        anyDeleteButton.tap()
        
        // Give time for deletion
        sleep(2)
        
        // Assert - Should have one less photo
        let photosAfterWithIds = app.otherElements.matching(NSPredicate(format: "identifier BEGINSWITH 'photo_card_'")).count
        XCTAssertEqual(photosAfterWithIds, photosBeforeWithIds - 1, "Should have one less photo after deletion")
    }
}

