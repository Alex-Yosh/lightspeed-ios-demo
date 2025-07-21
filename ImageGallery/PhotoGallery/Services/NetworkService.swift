//
//  NetworkService.swift
//  PhotoGallery
//
//  Created by Alex Yoshida on 2025-07-17.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchPhotos() async throws -> [PicsumPhoto]
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://picsum.photos/v2/list"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPhotos() async throws -> [PicsumPhoto] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            return try JSONDecoder().decode([PicsumPhoto].self, from: data)
        } catch {
            throw URLError(.cannotDecodeRawData)
        }
    }
}
