//
//  URLFactory.swift
//  Catogram
//
//  Created by Олег Крылов on 09/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import Foundation
import UIKit

final class URLFactory {
    private let xApiKey = "829c8b93-671a-4663-8afd-78b5bdf28472"
    private let baseUrl: String = "https://api.thecatapi.com/v1"
    
    init() {
        
    }
    
    func randomImageUrl() -> URLRequest {
        let methodUrl = "/images/search"
        guard let url = URL(string: baseUrl+methodUrl) else { fatalError("Bad URL") }
        var request = URLRequest(url: url)
        let headers = [
            "x-api-key": xApiKey
        ]
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func voteForCurrentImage(imageId: String, vote: Int) -> URLRequest {
        let methodUrl = "/votes"
        guard let url = URL(string: baseUrl+methodUrl) else { fatalError("Bad URL") }
        var request = URLRequest(url: url)
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
        guard let url = URL(string: baseUrl+methodUrl) else { fatalError("Bad URL") }
        var request = URLRequest(url: url)
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
        guard let url = URL(string: baseUrl+methodUrl+queryItem) else { fatalError("Bad URL") }
        var request = URLRequest(url: url)
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
        return request
    }
    
    func gerBreedsList() -> URLRequest {
        let methodUrl = "/breeds"
        guard let url = URL(string: baseUrl+methodUrl) else { fatalError("Bad URL") }
        var request = URLRequest(url: url)
        let headers = [
            "x-api-key": xApiKey
        ]
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func gerCategoryList() -> URLRequest {
        let methodUrl = "/categories"
        guard let url = URL(string: baseUrl+methodUrl) else { fatalError("Bad URL") }
        var request = URLRequest(url: url)
        let headers = [
            "x-api-key": xApiKey
        ]
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func searchForImage(name: String?, category: Int?) -> URLRequest {
        let queryItem: String
        if category == nil || category == 0 {
             queryItem = "?limit=90&breed_id=\(name ?? "")"
        } else if name == nil || name == "" {
             queryItem = "?limit=90&category_ids=\(category!)"
        } else {
             queryItem = "?limit=90&breed_id=\(name ?? "")&category_ids=\(category!)"
        }
        let methodUrl = "/images/search"
        guard let url = URL(string: baseUrl+methodUrl+queryItem) else { fatalError("Bad URL") }
        var request = URLRequest(url: url)
        let headers = [
            "x-api-key": xApiKey
        ]
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print(request)
        return request
    }
    
    func uploadedImagesByUser() -> URLRequest {
        let methodUrl = "/images"
        let queryItem = "?sub_id=\(Constants.currentUserUUID)&limit=100&order=ASC"
        guard let url = URL(string: baseUrl+methodUrl+queryItem) else { fatalError("Bad URL") }
        var request = URLRequest(url: url)
        let headers = [
            "x-api-key": xApiKey
        ]
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func uploadImage(image: Data) -> URLRequest {
        let methodUrl = "/images/upload"
        guard let url = URL(string: baseUrl+methodUrl) else { fatalError("Bad URL") }
        var request = URLRequest(url: url)
        
        let parameters = [
            "sub_id": Constants.currentUserUUID
            ] as [String : String]

        let boundary = "Boundary-\(UUID().uuidString)"
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(xApiKey)", forHTTPHeaderField: "x-api-key")
        request.httpBody = createBody(parameters: parameters,
                                boundary: boundary,
                                data: image,
                                mimeType: "image/jpeg",
                                filename: "hello.jpeg")
        return request
    }
    
    func deleteFromFavourites(imageId:String) -> URLRequest {
        let methodUrl = "/favourites/"
        guard let url = URL(string: baseUrl+methodUrl+imageId) else { fatalError("Bad URL") }
        var request = URLRequest(url: url)
        let headers = [
            "x-api-key": xApiKey
        ]
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func deleteFromUploaded(imageId:String) -> URLRequest {
        let methodUrl = "/images/"
        guard let url = URL(string: baseUrl+methodUrl+imageId) else { fatalError("Bad URL") }
        var request = URLRequest(url: url)
        let headers = [
            "x-api-key": xApiKey
        ]
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
}

