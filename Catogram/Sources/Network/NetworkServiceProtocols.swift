//
//  NetworkServiceProtocols.swift
//  Catogram
//
//  Created by Олег Крылов on 09/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import Foundation

protocol ImageNetworkProtocol {
    func getRandomImage(completion: @escaping (Result<[ImageResponse], Error>) -> Void)
    func voteForCurrentImage(id: String, vote: Int, completion: @escaping (Result<CompletionResponse, Error>) -> Void)
    func favCurrentImage(id: String, completion: @escaping (Result<CompletionResponse, Error>) -> Void)
    func getFavouritesImages(completion: @escaping (Result<[FavouritesResponse], Error>) -> Void)
}

struct ImageResponse: Decodable {
    let id: String?
    let url: String?
}

struct CompletionResponse: Decodable {
    let id: Int?
    let message: String?
}

struct FavouritesResponse: Decodable {
    let created_at: String?
    let id: Int?
    let image: FavoritesImageUrl
    let image_id: String?
    let sub_id: String?
}

struct FavoritesImageUrl: Decodable {
    let id: String?
    let url: String?
    
}

