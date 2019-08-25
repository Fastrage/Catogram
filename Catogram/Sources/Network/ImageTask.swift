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
    func imageDownloaded(position: Int, image: UIImage)
}

class ImageTask {
    
    let position: Int
    let url: URL
    let session: URLSession
    let cache = URLCache.shared
    let delegate: ImageTaskDownloadedDelegate
    
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
            if self.image == nil {
                if let data = self.cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        //self.image = image
                        self.delegate.imageDownloaded(position: self.position, image: image)
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
        self.cache.storeCachedResponse(cachedData, for: self.request)
        
        DispatchQueue.main.async {
            if self.url.absoluteString.contains("http") {
                self.save(url: self.url.absoluteString, image: image)
            }
            self.image = image
            self.delegate.imageDownloaded(position: self.position, image: image)
        }
        self.isFinishedDownloading = true
    }
}

extension ImageTask {
    func save(url: String, image: UIImage) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavouritesPhotoCache", in: managedContext)
        let options = NSManagedObject(entity: entity!,
                                      insertInto:managedContext)
        let newImageData = image.pngData()
        
        options.setValue(url, forKey: "imageUrl")
        options.setValue(newImageData, forKey: "image")
        
        do {
            try managedContext.save()
        } catch {
            print("error")
        }
    }
    
    func read(url: String) {
        do
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouritesPhotoCache")
            let predicate = NSPredicate(format: "imageUrl == %@", url)
            fetchRequest.predicate = predicate
            fetchRequest.returnsObjectsAsFaults = false
            let fetchedResults = try managedContext.fetch(fetchRequest)
            if fetchedResults.count > 0 {
                let image = fetchedResults.first as! NSManagedObject
                if let imageData = image.value(forKey: "image") {
                    guard let image = UIImage(data: imageData as! Data) else { return }
                    self.image = image
                    self.delegate.imageDownloaded(position: self.position, image: image)
                    self.isFinishedDownloading = true
                    print("succes return image")
            }
            }
        }
        catch {
                print("error")
        }
    }
    
    func deleteData() {
        
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouritesPhotoCache")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch {
            print("error")
        }
    }
}
 
