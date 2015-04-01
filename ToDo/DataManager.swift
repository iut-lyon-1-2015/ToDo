//
//  DataManager.swift
//  ToDo
//
//  Created by William Antwi on 01/04/2015.
//  Copyright (c) 2015 William Antwi. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    let managedObjectContext: NSManagedObjectContext
    let persistentStore: NSPersistentStore?
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    let managedObjectModel: NSManagedObjectModel
    
    class var sharedManager: DataManager {
        
        struct Singleton {
            static let instance = DataManager()
        }
        
        return Singleton.instance
    }
    
    func applicationDocumentDirectory() -> NSURL {
        
        let fileManager = NSFileManager.defaultManager()
        
        let urls = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        return urls[0] as NSURL
        
    }
    
    init() {
        
        let modelURL = NSBundle.mainBundle().URLForResource("ToDo", withExtension: "momd")!
        
        managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!
    
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        let documentURL = applicationDocumentDirectory()
        
        let storeURL = documentURL.URLByAppendingPathComponent("ToDo.sqlite")
        
        let options = [NSMigratePersistentStoresAutomaticallyOption : true]
        
        var error: NSError? = nil
        
        persistentStore = persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType,
            configuration: nil,
            URL: storeURL,
            options: options,
            error: &error)
        
        if persistentStore == nil {
            println("Error adding persistence store: \(error)")
            abort()
        }
    }
    
    func saveContext() {
        
        var error: NSError? = nil
        
        if managedObjectContext.hasChanges && !managedObjectContext.save(&error) {
            println("Failed to save context \(error), \(error?.userInfo)")
        }
    }    

}
