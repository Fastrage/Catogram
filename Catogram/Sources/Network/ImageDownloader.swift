//
//  ImageDownloader.swift
//  Catogram
//
//  Created by Олег Крылов on 09/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//
import UIKit
protocol iImageDownloader {
    func getPhoto(url1:String?, completion: @escaping (Result<UIImage?, Error>)  -> Void)
}

class ImageDownloader: iImageDownloader {
    let cache = URLCache.shared
    func getPhoto(url1:String?, completion: @escaping (Result<UIImage?, Error>) -> Void)  {
        
        guard let url1 = url1 else {
            return
        }
        
        guard let url = URL(string: url1) else{
            return
        }
        let request = URLRequest(url: url)
        if let data = self.cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            completion(.success(image))
        } else {
            URLSession.shared.dataTask(with: url)  { data, response, error in
                
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
