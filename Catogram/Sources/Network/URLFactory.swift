//
//  URLFactory.swift
//  Catogram
//
//  Created by Олег Крылов on 09/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import Foundation

class URLFactory {
    private let xApiKey = "829c8b93-671a-4663-8afd-78b5bdf28472"
    private let baseUrl: String = "https://api.thecatapi.com/v1"
    
    init() {
        
    }
    
    func randomImageUrl() -> URLRequest {
        let methodUrl = "/images/search"
        var request = URLRequest(url: URL(string: baseUrl+methodUrl)!)
        let headers = [
            "x-api-key": xApiKey
        ]
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func voteForCurrentImage(imageId: String, vote: Int) -> URLRequest {
        let methodUrl = "/votes"
        var request = URLRequest(url: URL(string: baseUrl+methodUrl)!)
        let headers = [
            "content-type": "application/json",
            "x-api-key": xApiKey
        ]
        let parameters = [
            "image_id": imageId,
            "sub_id": Constants.currentUserUUID,
            "value": vote
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        return request
    }
    
    func favCurrentImage(imageId:String) -> URLRequest {
        let methodUrl = "/favourites"
        var request = URLRequest(url: URL(string: baseUrl+methodUrl)!)
        let headers = [
            "content-type": "application/json",
            "x-api-key": xApiKey
        ]
        let parameters = [
            "image_id": imageId,
            "sub_id": Constants.currentUserUUID
            ] as [String : Any]
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        return request
    }
    
    func favouritesImagesForUser() -> URLRequest {
        let methodUrl = "/favourites"
        let queryItem = "?sub_id=\(Constants.currentUserUUID)"
        var request = URLRequest(url: URL(string: baseUrl+methodUrl+queryItem)!)
        let headers = [
            "x-api-key": xApiKey
        ]
        let parameters = [
            "sub_id": Constants.currentUserUUID
            ] as [String : Any]
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        print(request.description)
        return request
    }
    
    func gerBreedsList() -> URLRequest {
        let methodUrl = "/breeds"
        var request = URLRequest(url: URL(string: baseUrl+methodUrl)!)
        let headers = [
            "x-api-key": xApiKey
        ]
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        print(request.description)
        return request
    }
    
    func searchForImage(name: String?, category: String?) -> URLRequest {
        let methodUrl = "/images/search"
        let queryItem = "?limit=9&breed_id=\(name ?? "")"
        var request = URLRequest(url: URL(string: baseUrl+methodUrl+queryItem)!)
        let headers = [
            "x-api-key": xApiKey
        ]
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print(request.description)
        return request
    }
}

