//
//  MTCoreDataService.swift
//  MaxTest
//
//  Created by Dmitry Ivashin on 1/27/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

import CoreData

class MTCoreDataService {
    
    enum JSONKey {
        static let id = "id"
        static let title = "title"
        static let imageMedium = "image_medium"
        static let imageThumb = "image_thumb"
        static let contentUrl = "content_url"
    }
    
    func updateDataBase(with array: [[String: Any]])
    {
        clearDataBaseStore()
        
        for dictionary in array {
            let newItem = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.defaultName, into: context) as! Article
            newItem.articleID = dictionary[JSONKey.id] as! Int64
            newItem.title = dictionary[JSONKey.title] as? String
            newItem.imageMediumLink = dictionary[JSONKey.imageMedium] as? String
            newItem.imageThumbLink = dictionary[JSONKey.imageThumb] as? String
            newItem.contentUrl = dictionary[JSONKey.contentUrl] as? String
            newItem.timeStamp = NSDate()
            
            if let link = newItem.contentUrl, let url = URL(string: link) {
                newItem.contentDetailsHTML = try? String(contentsOf: url)
            }
        }
        
        saveContext()
    }
    
    func clearDataBaseStore()
    {
        let entities = managedObjectModel.entities
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let deleteReqest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(deleteReqest)
            } catch {
                print(error)
            }
        }
    }
    
    // API
    
    func getFetchResultsController(for entityName: String = CoreDataUtils.defaultName, with sortDescriptors: [NSSortDescriptor] = CoreDataUtils.defaultSortDescriptors, ascending: Bool = true) -> NSFetchedResultsController<NSFetchRequestResult>
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = sortDescriptors
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                       managedObjectContext: context,
                                       sectionNameKeyPath: nil,
                                       cacheName: CoreDataUtils.cacheName)
    }
    
    // Stack settitngs
    private let modelName = "MaxTest"
    
    lazy var context: NSManagedObjectContext = {
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.psc
        return managedObjectContext
    }()
    
    private lazy var psc: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.modelName)
        
        do {
            let options =
                [NSMigratePersistentStoresAutomaticallyOption : true]
            
            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType, configurationName: nil, at: url,
                options: options)
        } catch  {
            print("Error adding persistent store.")
        }
        
        return coordinator
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    func saveContext()
    {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
        }
    }
    
}
