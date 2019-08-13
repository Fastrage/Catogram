//
//  ImageDownloader.swift
//  Catogram
//
//  Created by Олег Крылов on 09/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//
import UIKit
protocol iImageDownloader {
    func getPhoto(url:String?, completion: @escaping (Result<UIImage?, Error>)  -> Void)
}

class ImageDownloader: iImageDownloader {
    let cache = URLCache.shared
    func getPhoto(url:String?, completion: @escaping (Result<UIImage?, Error>) -> Void)  {
        
        guard let url = url else {
            return
        }
        
        guard let urlFromString = URL(string: url) else{
            return
        }
        let request = URLRequest(url: urlFromString)
        if let data = self.cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            completion(.success(image))
        } else {
            URLSession.shared.dataTask(with: urlFromString)  { data, response, error in
                
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
                
                guard let image = UIImage.init(data: data) else {
                    return
                }
                guard let respone = response else {
                    print("no response")
                    return
                }
                let cachedData = CachedURLResponse(response: respone, data: data)
                self.cache.storeCachedResponse(cachedData, for: request)
                DispatchQueue.main.async {
                    completion(.success(image))
                }
                }
                .resume()
        }
    }
}
