//
//  ImageTask.swift
//  Catogram
//
//  Created by Олег Крылов on 17/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import UIKit
import CoreData

protocol ImageTaskDownloadedDelegate {
    func imageDownloaded(position: Int)
}

class ImageTask {
    
    private let position: Int
    let url: URL
    private let session: URLSession
    private let cache = URLCache.shared
    private let delegate: ImageTaskDownloadedDelegate
    
    var image: UIImage?
    
    private var task: URLSessionDownloadTask?
    private var resumeData: Data?
    
    private var isDownloading = false
    private var isFinishedDownloading = false
    
    private let request: URLRequest
    
    init(position: Int, url: URL, session: URLSession, delegate: ImageTaskDownloadedDelegate) {
        self.position = position
        self.url = url
        self.session = session
        self.delegate = delegate
        self.request = URLRequest(url: url)
    }
    
    func resume() {
        if !isDownloading && !isFinishedDownloading {
            isDownloading = true
            if let data = self.cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                    self.delegate.imageDownloaded(position: self.position)
                }
                self.isFinishedDownloading = true
            } else {
                if let resumeData = resumeData {
                    task = session.downloadTask(withResumeData: resumeData, completionHandler: downloadTaskCompletionHandler)
                } else {
                    task = session.downloadTask(with: url, completionHandler: downloadTaskCompletionHandler)
                }
                task?.resume()
            }
        }
    }
    
    func pause() {
        if isDownloading && !isFinishedDownloading {
            task?.cancel(byProducingResumeData: { (data) in
                self.resumeData = data
            })
            self.isDownloading = false
        }
    }
    
    private func downloadTaskCompletionHandler(url: URL?, response: URLResponse?, error: Error?) {
        if let error = error {
            print("Error downloading: ", error)
            return
        }
        
        guard let url = url else { return }
        guard let response = response else { return }
        guard let data = FileManager.default.contents(atPath: url.path) else { return }
        guard let image = UIImage(data: data) else { return }
        
        let cachedData = CachedURLResponse(response: response, data: data)
        self.cache.storeCachedResponse(cachedData, for: request)
        
        DispatchQueue.main.async {
            self.image = image
            self.delegate.imageDownloaded(position: self.position)
        }
        
        self.isFinishedDownloading = true
    }
}
