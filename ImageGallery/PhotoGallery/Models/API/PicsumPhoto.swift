//
//  PicsumPhoto.swift
//  ImageGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import Foundation

struct PicsumPhoto: Codable, Identifiable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
