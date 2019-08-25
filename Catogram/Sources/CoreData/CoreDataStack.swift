//
//  CoreDataStack.swift
//  Catogram
//
//  Created by Олег Крылов on 26/08/2019.
//  Copyright © 2019 OlegKrylov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class CoreDataStack {
    
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
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
