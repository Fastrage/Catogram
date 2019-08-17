//
//  NetworkService+Image.swift
//  Catogram
//
//  Created by Олег Крылов on 09/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//
import Foundation

class NetworkService {
    
    let urlFactory: URLFactory
    
    init(urlFactory: URLFactory) {
        self.urlFactory = urlFactory
    }
    
    func baseRequest<T: Decodable>(url: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.dataIsNil))
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedObject = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            }.resume()
    }
}

enum NetworkError: Error {
    case wrongUrl
    case dataIsNil
}

extension NetworkService: ImageNetworkProtocol {
    
    
    func favCurrentImage(id: String, completion: @escaping (Result<CompletionResponse, Error>) -> Void) {
        self.baseRequest(url: self.urlFactory.favCurrentImage(imageId: id), completion: completion)
    }
    
    func getRandomImage(completion: @escaping (Result<[ImageResponse], Error>) -> Void) {
        self.baseRequest(url: self.urlFactory.randomImageUrl(), completion: completion)
    }
    
    func voteForCurrentImage(id: String, vote: Int, completion: @escaping (Result<CompletionResponse, Error>) -> Void) {
        self.baseRequest(url: self.urlFactory.voteForCurrentImage(imageId: id, vote: vote), completion: completion)
    }
    
    func getFavouritesImages(completion: @escaping (Result<[FavouritesResponse], Error>) -> Void) {
        self.baseRequest(url: self.urlFactory.favouritesImagesForUser(), completion: completion)
    }
    
    func getBreedsList(completion: @escaping (Result<[Breed], Error>) -> Void) {
        self.baseRequest(url: self.urlFactory.gerBreedsList(), completion: completion)
    }
    
    func searchForImage(name: String?, category: String?, completion: @escaping (Result<[ImageResponse], Error>) -> Void) {
        self.baseRequest(url: self.urlFactory.searchForImage(name: name, category: category), completion: completion)
    }
}

