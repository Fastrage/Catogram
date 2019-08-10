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
    
    //var randomImage: URLRequest
    //var voteUpUrl: URLRequest
    //var voteDownUrl: URLRequest
    
    init() {
        
    }
    
    func randomImageUrl() -> URLRequest {
        let methodURl = "/images/search"
        var request = URLRequest(url: URL(string: baseUrl+methodURl)!)
        let headers = [
            "x-api-key": xApiKey
        ]
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func voteUpUrl(imageId: String, vote: Int) -> URLRequest {
        let methodURl = "/votes"
        var request = URLRequest(url: URL(string: baseUrl+methodURl)!)
        let headers = [
            "content-type": "application/json",
            "x-api-key": xApiKey
        ]
        let parameters = [
            "image_id": imageId,
            "sub_id": "my-user-1234",
            "value": vote
            ] as [String : Any]
       
            let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        return request
    }
    
    func favCurrentImage(imageId:String) -> URLRequest {
        let methodURl = "/votes"
        var request = URLRequest(url: URL(string: baseUrl+methodURl)!)
        let headers = [
            "content-type": "application/json",
            "x-api-key": xApiKey
        ]
        let parameters = [
            "image_id": imageId
            ] as [String : Any]
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        return request
    }
}

