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
    func getBreedsList(completion: @escaping (Result<[Breed], Error>) -> Void)
    func getCategoryList(completion: @escaping (Result<[Category], Error>) -> Void)
    func searchForImage(name: String?, category: Int?, completion: @escaping (Result<[ImageResponse], Error>) -> Void)
    func getUploadedImages(completion: @escaping (Result<[UploadedResponse], Error>) -> Void)
    func uploadImage(image: Data, completion: @escaping (Result<requestCompletionResponse, Error>) -> Void)
    func deleteFromFavourites(id: String, completion: @escaping (Result<requestCompletionResponse, Error>) -> Void)
    func deleteFromUploaded(id: String, completion: @escaping (Result<requestCompletionResponse?, Error>) -> Void)
    
}

struct ImageResponse: Decodable {
    let id: String?
    let url: String?
}

struct CompletionResponse: Decodable {
    let id: Int?
    let message: String?
}

struct requestCompletionResponse: Decodable {
    let level: String?
    let message: String?
    let status: Int?
}

struct FavouritesResponse: Decodable {
    let createdAt: String?
    let id: Int?
    let image: ImageResponse
    let imageId: String?
    let subId: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id
        case image
        case imageId = "image_id"
        case subId = "sub_id"
    }
}

struct UploadedResponse: Decodable {
    let createdAt: String?
    let id: String?
    let subId: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id
        case subId = "sub_id"
        case url
    }
}
