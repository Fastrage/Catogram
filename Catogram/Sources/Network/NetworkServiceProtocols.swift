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
    func voteForCurrentImage(id: String, vote: Int, completion: @escaping (Result<completionResponse, Error>) -> Void)
    func favCurrentImage(id: String, completion: @escaping (Result<completionResponse, Error>) -> Void)
}

struct ImageResponse: Decodable {
    let id: String?
    let url: String?
}

struct completionResponse: Decodable {
    let id: Int?
    let message: String?
}
